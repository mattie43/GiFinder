# search giphy
require_relative '../config/environment.rb'

def welcome_screen
    # Gif.display_gif("https://media.giphy.com/media/BLy7N6MJNYCeMeuB18/giphy.gif")

    system('clear')
    
    puts "Welcome to GiFinder!"
    puts "This app allows you to search the giphy database and save your favorite gifs to your account."
    puts "You can also sort your gifs into custom categories, and share your gifs with your friends!"
    
    choice = TTY::Prompt.new.select("What would you like to do?", %w(login sign\ up exit))

    case choice
    when "login"
        User.login
    when "sign up"
        User.sign_up
    when "exit"
        exit
    end
end

binding.pry