class Category < ActiveRecord::Base
    belongs_to :user, touch: true
    has_many :gifs    
end