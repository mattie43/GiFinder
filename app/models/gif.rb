class Gif < ActiveRecord::Base
    belongs_to :category, touch: true

    def self.search_giphy
        puts "Input search query or phrase:"
        query = gets.chomp
        # gifs or stickers?
        # url = "https://api.giphy.com/v1/gifs/search?api_key=#{ENV['GIPHY_KEY']}&q=#{query}&limit=10&offset=0&rating=g&lang=en"
        url = "https://api.giphy.com/v1/stickers/search?api_key=#{ENV['GIPHY_KEY']}&q=#{query}&limit=10&offset=0&rating=g&lang=en"
        uri = URI.parse(url)
        response = Net::HTTP.get_response(uri)
        search_results = JSON.parse(response.body)

        # show top 10 results, and select from there which to display
        titles_arr = []
        10.times { |x| titles_arr << {search_results["data"][x]["title"] => x} }
        answer = TTY::Prompt.new.enum_select("Which gif would you like to view?", titles_arr)

        # choose original url specifically
        gif_link = search_results["data"][answer]["images"]["original"]["url"]
        
        Gif.display_gif(gif_link)
        
        new_gif = Gif.new(link: gif_link)
        new_gif.save_or_share
    end

    def save_or_share
        prompt = TTY::Prompt.new
        answer = prompt.select("What would you like to do with this gif?", %w(Save Share Return\ to\ menu))
        case answer
        when "Save"
            self.save_gif
        when "Share"
            self.share_gif
        when "Return to menu"
            User.current_user.task_selection_screen
        end
    end

    def save_gif
        prompt = TTY::Prompt.new
        #display categories
        choices = User.current_user.categories.map { |c| c.name } << "Create new"
        answer = prompt.enum_select("Which category would you like to save this to?", choices)
        answer = prompt.ask("Enter new category name") if answer == "Create new"
        #check if category exists, then create
        self.category = User.current_user.categories.find_or_create_by(name: answer, user: User.current_user)
        self.nickname = prompt.ask("Please add a nickname to this gif:")
        self.save
        self.share_gif if prompt.yes?("Would you also like to share this gif?")
        User.current_user.task_selection_screen
    end

    def share_gif
        answer = TTY::Prompt.new.select("Where would you like to send this?", %w(Twitter Text Slack Return\ to\ menu))
        case answer
        when "Twitter"
            Twitter.tweet_gif(self)
            User.current_user.task_selection_screen
        when "Text"
            Text.text_gif(self)
            User.current_user.task_selection_screen
        when "Slack"
            Slack.slack_gif(self.link)
        when "Return to menu"
            User.current_user.task_selection_screen
        end
    end
    
    def self.view_top_trending
        # url = "https://api.giphy.com/v1/gifs/trending?api_key=#{ENV['GIPHY_KEY']}&limit=1&rating=g"
        url = "https://api.giphy.com/v1/stickers/trending?api_key=#{ENV['GIPHY_KEY']}&limit=10&rating=g"
        uri = URI.parse(url)
        response = Net::HTTP.get_response(uri)
        search_results = JSON.parse(response.body)
        
        # show top 10 results, and select from there which to display
        titles_arr = []
        10.times { |x| titles_arr << {search_results["data"][x]["title"] => x} }
        answer = TTY::Prompt.new.enum_select("Which gif would you like to view?", titles_arr)

        # choose original url specifically
        gif_link = search_results["data"][answer]["images"]["original"]["url"]
       
        Gif.display_gif(gif_link)

        new_gif = Gif.new(link: gif_link)
        new_gif.save_or_share
    end

    def self.display_gif(giphy_link)
        system 'clear'
        image = MiniMagick::Image.open(giphy_link)
        image.strip
        # ImageOptimizer.new(image.path, quiet: true).optimize
        
        gif_frames = image.frames.length - 1
        gif_frames = 15 if gif_frames > 15
        
        5.times do
            gif_frames.times do |x|
                system 'clear'
                Catpix::print_image image.frames[x].path,
                :limit_x => 0.8,
                :limit_y => 0.8,
                :center_x => false,
                :center_y => false,
                # :bg => "black",
                :bg_fill => false,
                :resolution => "low"
                sleep(0.09)
            end
        end
    end
end