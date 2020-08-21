class Gif < ActiveRecord::Base
    belongs_to :category, touch: true

    def self.search_giphy
        puts "Input search query or phrase:"
        query = gets.chomp
        
        url = "https://api.giphy.com/v1/stickers/search?api_key=#{ENV['GIPHY_KEY']}&q=#{query}&limit=10&offset=0&rating=g&lang=en"
        uri = URI.parse(url)
        response = Net::HTTP.get_response(uri)
        search_results = JSON.parse(response.body)

        self.display_top_ten(search_results)
    end

    def self.display_top_ten(search_results)
        titles_arr = []
        10.times { |x| titles_arr << {search_results["data"][x]["title"] => x} }
        answer = TTY::Prompt.new.enum_select("Which gif would you like to view?", titles_arr)
        gif_link = search_results["data"][answer]["images"]["original"]["url"]
        
        Gif.display_gif(gif_link)
        
        new_gif = Gif.new(link: gif_link)
        new_gif.save_or_share
    end

    def save_or_share
        prompt = TTY::Prompt.new
        options = Pastel.new.decorate("\e[32mSave,\e[36mShare,\e[35mView in browser,\e[31mReturn to menu\e[0m").split(",")
        answer = prompt.select("What would you like to do with this gif?", options)

        case answer
        when "\e[32mSave"
            self.save_gif
        when "\e[36mShare"
            self.share_gif
        when "\e[35mView in browser"
            Launchy.open(self.link)
            User.current_user.task_selection_screen
        when "\e[31mReturn to menu\e[0m"
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
        options = Pastel.new.decorate("\e[32mTwitter,\e[36mText,\e[35mSlack,\e[33mCopy Link,\e[31mReturn to menu\e[0m").split(",")
        answer = TTY::Prompt.new.select("Where would you like to send this?", options)
        case answer
        when "\e[32mTwitter"
            Twitter.tweet_gif(self)
        when "\e[36mText"
            Text.text_gif(self)
        when "\e[35mSlack"
            Slack.slack_gif(self.link)
        when "\e[33mCopy link"
            puts "Link to copy:"
            puts self.link
            puts "Press Enter to return to the task selection screen."
            gets.chomp
        end
        
        User.current_user.task_selection_screen
    end
    
    def self.view_top_trending
        url = "https://api.giphy.com/v1/stickers/trending?api_key=#{ENV['GIPHY_KEY']}&limit=10&rating=g"
        uri = URI.parse(url)
        response = Net::HTTP.get_response(uri)
        search_results = JSON.parse(response.body)

        self.display_top_ten(search_results)
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