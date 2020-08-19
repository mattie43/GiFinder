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
        # url = "https://api.giphy.com/v1/gifs/search?api_key=#{ENV['GIPHY_KEY']}&q=#{query}&limit=1&offset=0&rating=g&lang=en"
        url = "https://api.giphy.com/v1/stickers/search?api_key=#{ENV['GIPHY_KEY']}&q=#{query}&limit=1&offset=0&rating=g&lang=en"
        uri = URI.parse(url)
        response = Net::HTTP.get_response(uri)
        search_results = JSON.parse(response.body)
        
        # choose original url specifically
        gif_link = search_results["data"][0]["images"]["original"]["url"]
        # binding.pry
        
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
        url = URI("https://quick-easy-sms.p.rapidapi.com/send")

        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        request = Net::HTTP::Post.new(url)
        request["x-rapidapi-host"] = ''
        request["x-rapidapi-key"] = ''
        request["content-type"] = 'application/x-www-form-urlencoded'

        puts "Enter the number you would like to send this gif to:"
        number = gets.chomp
        puts "Enter a message to add:"
        message = gets.chomp
        request.body = "message=#{message}&toNumber=1#{number}"
        # show them a seccessful message sent
        User.current_user.task_selection_screen
    end


    # in Gif class (class method)
    def self.view_gif_of_the_day
        # url = "https://api.giphy.com/v1/gifs/trending?api_key=#{ENV['GIPHY_KEY']}&limit=1&rating=g"
        url = "https://api.giphy.com/v1/stickers/trending?api_key=#{ENV['GIPHY_KEY']}&limit=1&rating=g"
        uri = URI.parse(url)
        response = Net::HTTP.get_response(uri)
        search_results = JSON.parse(response.body)
        
        # choose original url specifically
        gif_link = search_results["data"][0]["images"]["original"]["url"]
        
        # REMOVE AFTER TEST
        puts gif_link
        # Gif.display_gif(gif_link)

        new_gif = Gif.new(link: gif_link)
        new_gif.save_or_share
    end

    def self.display_gif(giphy_link)
        system 'clear'
        image = MiniMagick::Image.open(giphy_link)
        # ImageOptimizer.new(image.path, quiet: true).optimize
        # not sure if we want to resize here or not
        # image.resize "100x100"
        # binding.pry
    
        gif_frames = image.frames.length - 1

        # attempt to save, then load all the frames for faster output
    
        5.times do
            gif_frames.times do |x|
                Catpix::print_image image.frames[x].path,
                :limit_x => 0.8,
                :limit_y => 0.8,
                :center_x => false,
                :center_y => false,
                :bg => "black",
                :bg_fill => true,
                :resolution => "low"
                sleep(0.1)
                system 'clear'
            end
        end
    end
end