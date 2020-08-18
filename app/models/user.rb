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

# User class (class method)
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
end