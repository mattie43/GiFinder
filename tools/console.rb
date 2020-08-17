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

def welcome_screen
    # stretch: put a cool welcome gif here

    # ask user to login or sign up
end

# User class (class method)
def login
    # get username
    # get password
    # set current user accordingly (global/class variable)
end

# User class (class method)
def sign_up
    # get username
    # get password
    # check if username already exists, if so ask for a different one
    # save as new account
    # then ask to login
end

# User class (instance method)
def task_selection_screen
    # create a category
    # view existing categories (and then gifs within them, but we'll get to that)
    # select a category
    # search giphy
    # gif of the day
    # sign out
end

# always have option to return to selection screen

# User class (instance method)
def create_category
    # create category, then send back to selection screen
end

# User class (instance method)
def view_categories
    # check if categories, if none ask if user wishes to create one
    # display list of categories, then ask to choose or return to task selection screen
end

# User class (instance method)
def select_category
    # if category doesn't exist, ask if you want to create it
    # if not, error? and send back to selection screen
    # display gif nicknames
    # ask to choose gif or return to task selection screen
end

# Category class (instance method)
def choose_gif
    # ask for nickname
    # stretch: display gif (if not just link)
    # stretch: ask if you want to share etc
end

# in Gif class (class method)
def search_giphy
    # search, find, display
    # user can save to category or share (or save then share)
end

# in Gif class (class method)
def view_gif_of_the_day
    # retrieve and display
    # option to save to category or share
    # or return to selection screen
end

# User class (instance method)
def sign_out
    # clear user instance? set to nil or w/e
    # return to welcome screen
end

binding.pry