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
    end

    
end