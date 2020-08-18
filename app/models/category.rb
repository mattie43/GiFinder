# -category belongs to user
# -category has many gifs
class Category < ActiveRecord::Base
    belongs_to :user
    has_many :gifs

        # Category class (instance method)
    def choose_gif
        # ask for nickname
        # stretch: display gif (if not just link)
        # stretch: ask if you want to share etc
        puts "Input the name of the gif you're looking for:"
        name = gets.chomp
        gif = Gif.all.find_by(category: self, nickname: name)
        if gif == nil
            puts "There is no gif with that nickname in this category."
        else
            puts gif.link
            # add logic for sharing
        end
    end

    
end