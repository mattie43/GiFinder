# search giphy
require_relative '../config/environment.rb'

$return_to_menu = Pastel.new.decorate("\e[31mReturn to menu\e[0m")

def open_program
    system 'clear'
    Gif.display_gif("https://media.giphy.com/media/BLy7N6MJNYCeMeuB18/giphy.gif")
    welcome_screen
end

def welcome_screen    
    #green, cyan, magenta, yellow, red
    puts Pastel.new.decorate("                               \e[32mWelcome \e[36mto \e[35mGi\e[33mF\e[31minder!\e[0m")
    puts "This app allows you to search the giphy database and save your favorite gifs to your account."
    puts "You can also sort your gifs into custom categories, and share your gifs with your friends!"
    
    choices_colored = Pastel.new.decorate("\e[32mLogin,\e[33mSign up,\e[31mExit\e[0m").split(",")
    choice = TTY::Prompt.new.select("What would you like to do?", choices_colored)

    case choice
    when "\e[32mLogin"
        User.login
    when "\e[33mSign up"
        User.sign_up
    when "\e[31mExit\e[0m"
        exit
    end
end

# seems to load and display gif significantly faster then catpix
# but requires rmagick and tco
# def img_test
#     image = MiniMagick::Image.open("https://media.giphy.com/media/MWtVSXiqOYuqdfvqb0/giphy.gif")
#     image.resize "50x50"
#     gif_frames = image.frames.length - 1
#     5.times do
#         gif_frames.times do |x|
#             img = Magick::Image::read(image.frames[x].path).first
#             # img2 = image.frames[x].path
#             # binding.pry
#             img.each_pixel do |pixel, col, row|
#                 c = [pixel.red, pixel.green, pixel.blue].map { |v| 256 * (v / 65535.0) }
#                 pixel.opacity == 65535 ? print("  ") : print("  ".bg c)
#                 # binding.pry
#                 puts if col >= img.columns - 1
#             end
#             sleep(0.09)
#             system 'clear'
#         end
#     end
# end


binding.pry