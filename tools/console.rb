# search giphy
require_relative '../config/environment.rb'

def welcome_screen
    Gif.display_gif("https://media.giphy.com/media/BLy7N6MJNYCeMeuB18/giphy.gif")
end

binding.pry