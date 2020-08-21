class Category < ActiveRecord::Base
    belongs_to :user, touch: true
    has_many :gifs    

    def self.view_gifs(category_name)
        system('clear')

        chosen_category = User.current_user.categories.find_by(name: category_name)
        gif_names = chosen_category.gifs.all.map { |gif| gif.nickname } << $return_to_menu
        gif_choice = TTY::Prompt.new.enum_select("Select a gif, or return to menu.", gif_names)
        gif_ins = chosen_category.gifs.find_by(nickname: gif_choice)

        if chosen_category.gifs.find_by(nickname: gif_choice)
            chosen_category.delete_share_move(gif_ins)
        elsif gif_choice == $return_to_menu
            User.current_user.task_selection_screen
        end
    end

    def delete_share_move(gif_ins)
        Gif.display_gif(gif_ins.link)
        
        options = Pastel.new.decorate("\e[32mRename,\e[36mDelete,\e[35mMove categories,\e[33mShare,\e[32mView in browser,\e[31mReturn to menu\e[0m").split(",")
        answer = TTY::Prompt.new.select("What would you like to do with this gif?", options)
        
        case answer
        when "\e[32mRename"
            puts "What is the new nickname for the gif?\n"
            new_name = gets.chomp

            gifs.find_by(nickname: gif_ins.nickname).update(nickname: new_name)

            puts "This gif's nickname has been changed to #{new_name}. Push Enter to return to the task selection screen."
            gets.chomp
        when "\e[36mDelete"
            system 'clear'
            print TTY::Box.warn("Gif will be deleted permanently.")
            key_pressed = TTY::Prompt.new.keypress("Press ENTER to continue with deletion, or ESC to cancel.", keys: [:return, :escape])
            
            gif_ins.delete if key_pressed == "\r"
        when "\e[35mMove categories"
            category_names = user.categories.all.map { |category| category.name }
            category_choice = TTY::Prompt.new.enum_select("Select a category to move this gif to.", category_names)
            category_ins = user.categories.find_by(name: category_choice)

            gif_ins.update(category: category_ins)
        when "\e[33mShare"
            gif_ins.share_gif
        when "\e[32mView in browser"
            Launchy.open(gif_ins.link)
        end
        User.current_user.task_selection_screen
    end
end
