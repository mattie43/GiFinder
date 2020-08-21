class Category < ActiveRecord::Base
    belongs_to :user, touch: true
    has_many :gifs    

    def view_gifs(category_name)
        system('clear')

        chosen_category = self.categories.find_by(name: category_name)
        
        gif_names = chosen_category.gifs.all.map { |gif| gif.nickname } << "Return to menu"

        gif_choice = TTY::Prompt.new.enum_select("Select a gif, or return to menu.", gif_names)

        gif_ins = chosen_category.gifs.find_by(nickname: gif_choice)
        if chosen_category.gifs.find_by(nickname: gif_choice)
            # display, then delete/share/move
            self.delete_share_move(gif_ins)
        elsif gif_choice == "Return to menu"
            User.task_selection_screen
        end
    end

    def delete_share_move(gif_ins)
        Gif.display_gif(gif_ins.link)
        options = %w(Delete Move\ categories Share Return\ to\ menu)
        answer = TTY::Prompt.new.select("What would you like to do with this gif?", options)
        case answer
        when "Delete"
            system 'clear'
            print TTY::Box.warn("Gif will be deleted permanently.")
            key_pressed = TTY::Prompt.new.keypress("Press ENTER to continue with deletion, or ESC to cancel.", keys: [:return, :escape])
            gif_ins.delete if key_pressed == "\r"
            self.task_selection_screen
        when "Move categories"
            # add move
        when "Share"
            gif_ins.share_gif
        when "Return to menu"
            self.task_selection_screen
        end
    end
end
