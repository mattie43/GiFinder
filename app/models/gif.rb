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
        url = "https://api.giphy.com/v1/gifs/search?api_key=xS31BcM9rwVyfxhGdCMU8AGypUBgDyn7&q=#{query}&limit=25&offset=0&rating=g&lang=en"
        uri = URI.parse(url)
        response = Net::HTTP.get_response(uri)
        search_results = JSON.parse(response.body)
        
        # choose original url specifically
        gif_link = search_results["data"][0]["url"]
        # display gif
        puts gif_link
        new_gif = Gif.new(link: gif_link)
        new_gif.save_or_share
    end

    def save_or_share
        puts "Would you like to 'save' or 'share' this gif?"
        puts "You can also 'return' to the selection screen."
        save_share = gets.chomp
        if save_share.downcase == "save"
            self.save_gif
        elsif save_share.downcase == "share"
            self.share_gif
        elsif save_share.downcase == "return"
            welcome_screen
        else
            puts "Invalid input"
            self.save_or_share
        end
    end

    def save_gif
        puts "Which category would you like to save this too?"
        puts "You can also create a new category by typing it now!"
        #display categories
        User.current_user.categories.each { |c| puts c.name }
        answer = gets.chomp
        #check if category exists, then create
        category = User.current_user.categories.find_or_create_by(name: answer, user: User.current_user)
        self.category = category
        puts "Please add a nickname to this gif:"
        self.nickname = gets.chomp
        self.save

        # maybe add sharing
        puts "Would you also like to share this gif? (y/n)"
        input = gets.chomp
        self.share_gif if input.downcase == "y"
        User.current_user.task_selection_screen if input.downcase == "n"
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
        welcome_screen
    end


    # in Gif class (class method)
    def self.view_gif_of_the_day
        url = "https://api.giphy.com/v1/gifs/trending?api_key=xS31BcM9rwVyfxhGdCMU8AGypUBgDyn7&limit=1&rating=g"
        uri = URI.parse(url)
        response = Net::HTTP.get_response(uri)
        search_results = JSON.parse(response.body)
        
        # choose original url specifically
        gif_link = search_results["data"][0]["url"]
        # display gif
        puts gif_link
        new_gif = Gif.new(link: gif_link)
        new_gif.save_or_share
    end
end