class Category < ActiveRecord::Base
	belongs_to :user, touch: true
	has_many :gifs    

	def self.view_gifs(user, category_name)
		system('clear')

		chosen_category = user.categories.find_by(name: category_name)
		
		gif_names = chosen_category.gifs.all.map { |gif| gif.nickname } << "Return to menu"

		gif_choice = TTY::Prompt.new.enum_select("Select a gif, or return to menu.", gif_names)

		gif_ins = chosen_category.gifs.find_by(nickname: gif_choice)
		if chosen_category.gifs.find_by(nickname: gif_choice)
			# display, then delete/share/move
			chosen_category.delete_share_move(user, gif_ins)
		elsif gif_choice == "Return to menu"
			user.task_selection_screen
		end
	end

	def delete_share_move(user, gif_ins)
		Gif.display_gif(gif_ins.link)
		options = %w(Rename Delete Move\ categories Share view\ in\ browser Return\ to\ menu)
		answer = TTY::Prompt.new.select("What would you like to do with this gif?", options)
		case answer
		when "Rename"
			puts "What is the new nickname for the gif?\n"
			new_name = gets.chomp

			gifs.find_by(nickname: answer).update(nickname: new_name)

			puts "This gif's nickname has been changed from #{answer} to #{new_name}. Push Enter to return to the task selection screen."
			gets.chomp
			user.task_selection_screen

		when "Delete"
			system 'clear'
			print TTY::Box.warn("Gif will be deleted permanently.")
			key_pressed = TTY::Prompt.new.keypress("Press ENTER to continue with deletion, or ESC to cancel.", keys: [:return, :escape])
			gif_ins.delete if key_pressed == "\r"
			user.task_selection_screen
		when "Move categories"
			#
		when "Share"
			gif_ins.share_gif
		when "view in browser"
			Launchy.open(gif_ins.link)
			user.task_selection_screen
		when "Return to menu"
			user.task_selection_screen
		end
	end
end
