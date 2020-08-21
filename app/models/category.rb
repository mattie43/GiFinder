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
            self.task_selection_screen
        end
    end
end
