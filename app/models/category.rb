# -category belongs to user
# -category has many gifs
class Category < ActiveRecord::Base
    belongs_to :user, touch: true
    has_many :gifs    
end