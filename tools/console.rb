# search giphy
require_relative '../config/environment.rb'


def open_program
  system 'clear'
  Gif.display_gif("https://media.giphy.com/media/BLy7N6MJNYCeMeuB18/giphy.gif")
  welcome_screen
end

def welcome_screen    
  #green, cyan, magenta, red, yellow
  puts Pastel.new.decorate("                               \e[32mWelcome \e[36mto \e[35mGi\e[31mF\e[33minder!\e[0m")
  puts "This app allows you to search the giphy database and save your favorite gifs to your account."
  puts "You can also sort your gifs into custom categories, and share your gifs with your friends!"

  choice = TTY::Prompt.new.select("What would you like to do?", %w(login sign\ up exit))

  case choice
  when "Login"
    User.login
  when "Sign up"
    User.sign_up
  when "Exit"
    exit
  end
end

binding.pry