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
        system('clear')

        username = TTY::Prompt.new.ask("Please enter your username:")
        password = TTY::Prompt.new.mask("Please enter your password:")

        if !self.find_by(username: username).try(:authenticate, password)
            puts "Your username or password is incorrect, please try again."
            welcome_screen
        else
            self.current_user = self.find_by(username: username)
            self.current_user.task_selection_screen
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
        system('clear')

        username = TTY::Prompt.new.ask("Please enter your username:")
        if username_taken?(username)
            puts "That username is taken. Push Enter to try again."
            gets.chomp
            self.sign_up
        else
            password = TTY::Prompt.new.mask("Please enter your password:")
        
            self.create(username: username, password: password)
            puts "Congratulations, your account has been created! Push Enter to continue."
            gets.chomp
            welcome_screen
        end
    end

    def sign_out
        self.class.current_user = false
        puts "You have been signed out."
        welcome_screen
    end

    def task_selection_screen
        system('clear')

        task = TTY::Prompt.new.select("What would you like to do?", %w(
            create\ a\ category
            view\ existing\ categories
            search\ for\ a\ gif
            view\ the\ gif\ of\ the\ day
            sign\ out
        ))

        case task
        when "create a category"
            self.create_category
        when "view existing categories"
            self.view_categories
        when "search for a gif"
            Gif.search_giphy
        when "view the gif of the day"
            Gif.view_gif_of_the_day
        when "sign out"
            self.sign_out
        end
    end

    def return_to_selection_screen
        puts "To return to the task selection screen, hit the Enter or Return key."
        gets.chomp
        self.task_selection_screen
    end

    def create_category
        system('clear')

        new_category_name = TTY::Prompt.new.ask("What is the name of the new category?\n")

        self.categories.find_or_create_by(name: new_category_name, user_id: self.id)

        puts "Thank you, your category has been created."
        self.return_to_selection_screen
    end

    # User class (instance method)
    def view_categories
        system('clear')

        if self.categories.length == 0
            input = TTY::Prompt.new.select("You have not created any categories yet. What would you like to do?", %w(create\ a\ category return\ to\ menu))

            if input == "create a category"
                self.create_category
            elsif input == "return to menu"
                self.task_selection_screen
            end

        else
            category_names = self.categories.all.map do |category|
                category.name
            end

            category_names << "return to menu"

            category_choice = TTY::Prompt.new.select("Select a category to view its gifs, or return to menu.", category_names)

            if self.categories.find_by(name: category_choice)
                self.view_gifs(category_choice)
            elsif category_choice == "return to menu"
                self.task_selection_screen
            end
        end
    end

    def view_gifs(category_name)
        system('clear')

        chosen_category = self.categories.find_by(name: category_name)
        
        gif_names = chosen_category.gifs.all.map do |gif|
            gif.nickname
        end

        gif_names << "return to menu"

        gif_choice = TTY::Prompt.new.select("Select a gif, or return to menu.", gif_names)

        if chosen_category.gifs.find_by(nickname: gif_choice)
            # TODO: IMPLEMENT 
            # Gif.view_gif(gif_choice)
        elsif gif_choice == "return to menu"
            self.task_selection_screen
        end
    end

end