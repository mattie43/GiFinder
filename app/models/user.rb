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
    puts "What would you like to do?"
    puts "To create a category, type \"new category\""
    puts "To view existing categories, type \"view categories\""
    puts "To select a category, type \"select category\""
    puts "To search for a gif, type \"search\""
    puts "To view the gif of the day, type \"gif of the day\""
    puts "To sign out, type \"sign out\""
    
    task = gets.chomp

    case task
    when "new category"
        self.create_category
    when "view categories"
        self.view_categories
    when "select category"
        self.select_category
    when "search"
        Gif.search_giphy
    when "gif of the day"
        Gif.view_gif_of_the_day
    when "sign out"
        self.sign_out
    else
        puts "That input is invalid, please try again."
        task_selection_screen
    end
end

# always have option to return to selection screen

# User class (instance method)
def create_category
    puts "What is the name of the new category?"
    new_category = gets.chomp

    Category.create(name: new_category, user_id: self.id)

    puts "Thank you, your category has been created. To return to the task selection screen, hit the Enter or Return key."
    gets.chomp
    self.task_selection_screen

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