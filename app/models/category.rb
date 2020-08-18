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
            puts "Would you like to share this gif? (y/n)"
            input = gets.chomp
            gif.share_gif if input.downcase == "y"
        end
    end

    
end