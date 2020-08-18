# search giphy
require_relative '../config/environment.rb'

def search_giphy
    puts "Input search term to search"
    query = gets.chomp
    url = "https://api.giphy.com/v1/gifs/search?api_key=xS31BcM9rwVyfxhGdCMU8AGypUBgDyn7&q=#{query}&limit=25&offset=0&rating=g&lang=en"
    uri = URI.parse(url)
    response = Net::HTTP.get_response(uri)
    search_results = JSON.parse(response.body)

    #choose original url specifically
    ap search_results["data"][0]["url"]
end

def img_test
    image = MiniMagick::Image.open("https://media.giphy.com/media/wHe2BPdK5moB6Rjy4d/giphy.gif")
    image2 = Magick::Image.read(image.path)
    binding.pry
    # adding gifsicle to cut frames out

    # 5.times do
    image.each do |frame|
        binding.pry
        Catpix::print_image frame.filename,
        :limit_x => 1.0,
        :limit_y => 1.0,
        :center_x => false,
        :center_y => true,
        :bg => "white",
        :bg_fill => false,
        :resolution => "low"
        sleep(0.09)
        system 'clear'
    end
    # end
    # image.contrast
    # image.resize "100x100"
    # image.write("anim.gif")

    # Catpix::print_image image.path,
    #     :limit_x => 1.0,
    #     :limit_y => 0,
    #     :center_x => true,
    #     :center_y => true,
    #     :bg => "white",
    #     :bg_fill => true,
    #     :resolution => "low"
    # binding.pry
end

def frame_one
    Catpix::print_image "firstframe.gif",
        :limit_x => 0.5,
        :limit_y => 0.5,
        :center_x => true,
        :center_y => true,
        :bg => "white",
        :bg_fill => false,
        :resolution => "low"
    sleep (0.09)
    system 'clear'  
end
def frame_two
    Catpix::print_image "secondframe.gif",
        :limit_x => 0.5,
        :limit_y => 0.5,
        :center_x => true,
        :center_y => true,
        :bg => "white",
        :bg_fill => false,
        :resolution => "low"
    sleep (0.09)
    system 'clear'  
end
def frame_three
    Catpix::print_image "thirdframe.gif",
        :limit_x => 0.5,
        :limit_y => 0.5,
        :center_x => true,
        :center_y => true,
        :bg => "white",
        :bg_fill => false,
        :resolution => "low"
    sleep (0.09)
    system 'clear'  
end

def gif_test
    system 'clear'
    5.times do
        frame_one
        frame_two
        frame_three
    end
end

def welcome_screen
    # stretch: put a cool welcome gif here

    # ask user to login or sign up
end


binding.pry
