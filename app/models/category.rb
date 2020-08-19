# -category belongs to user
# -category has many gifs
class Category < ActiveRecord::Base
    belongs_to :user
    has_many :gifs

        # Category class (instance method)
    def find_gif
        prompt = TTY::Prompt.new
        # ask for nickname
        # stretch: display gif (if not just link)
        # stretch: ask if you want to share etc
        name = prompt.ask("Enter the name of the gif you're looking for:") 
        gif = Gif.all.find_by(category: self, nickname: name)

        if gif == nil
            puts "There is no gif with that nickname in this category."
        else
            Gif.display_gif(gif.link)
            gif.share_gif if prompt.yes?("Would you like to share this gif?") 
        end
    end

    
end