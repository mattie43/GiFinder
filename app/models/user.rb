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
            print TTY::Box.error("Incorrect username or password!")
            sleep(2.0)
            self.login
        else
            self.current_user = self.find_by(username: username)
            print TTY::Box.success("Welcome, #{username}!")
            sleep(2.0)
            self.current_user.task_selection_screen
        end
        
    end

    def self.username_taken?(username)
        self.find_by(username: username)
    end

    def self.sign_up
        system('clear')

        username = TTY::Prompt.new.ask("Please enter your username:")
        if username_taken?(username)
            print TTY::Box.info("That username is already taken!")
            sleep(2.0)
            self.sign_up
        else
            password = TTY::Prompt.new.mask("Please enter your password:")
            self.create(username: username, password: password)
            print TTY::Box.success("Account created! Please sign in now.")
            sleep(2.0)
            system 'clear'
            welcome_screen
        end
    end

    def sign_out
        self.class.current_user = false
        print TTY::Box.success("Successfully signed out!")
        sleep(2.0)
        system 'clear'
        welcome_screen
    end

    def task_selection_screen
        system('clear')

        options = Pastel.new.decorate("\e[32mCreate a category,\e[36mView existing categories,\e[35mSearch for a gif,\e[33mView the top trending gifs,\e[31mSign out\e[0m").split(",")
        task = TTY::Prompt.new.select("What would you like to do?", options)

        case task
        when "\e[32mCreate a category"
            self.create_category
        when "\e[36mView existing categories"
            self.view_categories
        when "\e[35mSearch for a gif"
            Gif.search_giphy
        when "\e[33mView the top trending gifs"
            Gif.view_top_trending
        when "\e[31mSign out\e[0m"
            self.sign_out
        end
    end

    def create_category
        system('clear')

        new_category_name = TTY::Prompt.new.ask("What is the name of the new category?\n")

        category_check = self.categories.find_by(name: new_category_name, user_id: self.id)

        if category_check == nil
            self.categories.create(name: new_category_name, user_id: self.id)
            print TTY::Box.success("#{new_category_name} has been successfully created!")
        else
            print TTY::Box.info("#{new_category_name} already exists!")
        end
        
        sleep(2.0)
        self.task_selection_screen
    end

    # User class (instance method)
    def view_categories
        system('clear')

        if self.categories.length == 0
            options = Pastel.new.decorate("\e[32mCreate a category,\e[31mReturn to menu\e[0m").split(",")
            input = TTY::Prompt.new.select("You have not created any categories yet. What would you like to do?", options)

            if input == "\e[32mCreate a category"
                self.create_category
            elsif input == "\e[31mReturn to menu\e[0m"
                self.task_selection_screen
            end
        else
            category_names = self.categories.all.map { |category| category.name } << $return_to_menu
            category_choice = TTY::Prompt.new.enum_select("Select a category to change its name or view its gifs, or return to menu.", category_names)

            if self.categories.find_by(name: category_choice)
                options = Pastel.new.decorate("\e[32mView gifs,\e[36mChange name").split(",")
                choice = TTY::Prompt.new.select("What would you like to do with the #{category_choice} category?", options)

                case choice
                when "\e[32mView gifs"
                    Category.view_gifs(category_choice)
                when "\e[36mChange name"
                    new_name = TTY::Prompt.new.ask("What is the new name for the category?\n")

                    categories.find_by(name: category_choice).update(name: new_name)
                    puts "The #{category_choice} category has been renamed to the #{new_name} category. Push Enter to return to the task selection screen."
                    gets.chomp
                    self.task_selection_screen
                end
            elsif category_choice == $return_to_menu
                self.task_selection_screen
            end
        end
    end
end