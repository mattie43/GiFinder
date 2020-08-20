# -gif belongs to user through category
# -gif belongs to category
class Gif < ActiveRecord::Base
    belongs_to :category, touch: true
    # delegate :user, :to => :category, :allow_nil => true

    def self.search_giphy
        # search, find, display
        # user can save to category or share (or save then share)
        puts "Input search query or phrase:"
        query = gets.chomp
        # gifs or stickers?
        # url = "https://api.giphy.com/v1/gifs/search?api_key=#{ENV['GIPHY_KEY']}&q=#{query}&limit=10&offset=0&rating=g&lang=en"
        url = "https://api.giphy.com/v1/stickers/search?api_key=#{ENV['GIPHY_KEY']}&q=#{query}&limit=10&offset=0&rating=g&lang=en"
        # display multiple gifs titles
        # then display what they want
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
        answer = prompt.enum_select("Which category would you like to save this too?", choices)
        answer = prompt.ask("Enter new category name") if answer == "Create new"
        #check if category exists, then create
        self.category = User.current_user.categories.find_or_create_by(name: answer, user: User.current_user)
        self.nickname = prompt.ask("Please add a nickname to this gif:")
        self.save
        self.share_gif if prompt.yes?("Would you also like to share this gif?")
        User.current_user.task_selection_screen
    end

    def share_gif
        answer = TTY::Prompt.new.select("Where would you like to send this?", %w(Twitter Text Return\ to\ menu))
        case answer
        when "Twitter"
            self.tweet_gif
        when "Text"
            self.text_gif
        when "Return to menu"
            User.current_user.task_selection_screen
        end
    end

    def text_gif
        url = URI("https://quick-easy-sms.p.rapidapi.com/send")

        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        request = Net::HTTP::Post.new(url)
        request["x-rapidapi-host"] = 'quick-easy-sms.p.rapidapi.com'
        request["x-rapidapi-key"] = ENV['RAPID_API_KEY']
        request["content-type"] = 'application/x-www-form-urlencoded'

        puts "Enter the number you would like to send this gif to:"
        number = gets.chomp
        puts "Enter a message to add:"
        message = gets.chomp
        request.body = "message=#{message}\n#{self.link}&toNumber=1#{number}"
        print TTY::Box.success("Message sent successfully!")
        sleep(2.0)
        User.current_user.task_selection_screen
    end

    def tweet_gif
        # url = "https://api.twitter.com/oauth/request_token"
        # uri = URI.parse(url)
        # response = Net::HTTP.get_response(uri)
        # search_results = JSON.parse(response.body)
        client = Twitter::REST::Client.new do |config|
            config.consumer_key        = ENV['TWITTER_KEY']
            config.consumer_secret     = ENV['TWITTER_SECRET']
            config.bearer_token        = ENV['TWITTER_BEARER_TOKEN']
            config.access_token        = ENV['ACCESS_TOKEN']
            config.access_token_secret = ENV['ACCESS_SECRET']
        end
        message = TTY::Prompt.new.ask("What would you like to say with this gif?")
        client.update("#{message}\n#{self.link}")
        print TTY::Box.success("Tweet made successfully!")
        User.current_user.task_selection_screen

        # url = URI("https://dev-udmy9c0g.us.auth0.com/api/v2/users/USER_ID")

        # http = Net::HTTP.new(url.host, url.port)
        # http.use_ssl = true
        # http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        # request = Net::HTTP::Get.new(url)
        # request["authorization"] = 'Bearer #{ENV['OAUTH_BEARER]}'

        # response = http.request(request)
        # puts response.read_body
    end


    # in Gif class (class method)
    def self.view_top_trending
        # add top 10 trending
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
        # not sure if we want to resize here or not
        # image.resize "100x100"
        # binding.pry
        
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
                :bg => "black",
                :bg_fill => true,
                :resolution => "low"
                sleep(0.09)
            end
        end
    end
end