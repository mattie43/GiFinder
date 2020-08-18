# -user has many categories
# -user has many gifs through categories

class User < ActiveRecord::Base
    has_many :categories
    has_many :gifs, through: :categories
    @@current_user = false

    has_secure_password

    def self.current_user
        @@current_user
    end

    def self.current_user=(user)
        @@current_user = user
    end

    def self.login
        puts "Please enter your username:"
        username = gets.chomp
        puts "Please enter your password:"
        password = gets.chomp

        if !self.find_by(username: username).try(:authenticate, password)
            puts "Your username or password is incorrect, please try again."
            welcome_screen
        else
            self.current_user = self.find_by(username: username)
        end
    end

    def self.username_taken?(username)
        if self.find_by(username: username)
            true 
        else
            false
        end
    end

    def self.sign_up

        puts "Please enter your username:"
        username = gets.chomp
        if username_taken?(username)
            puts "That username is taken, please try again."
            self.sign_up
        else
            puts "Please enter your password:"
            password = gets.chomp
        
            self.create(username: username, password: password)
            puts "Congratulations, your account has been created!"
            welcome_screen
        end
    end

    def sign_out
        self.class.current_user = false
        welcome_screen
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
end