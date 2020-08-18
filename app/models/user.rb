# -user has many categories
# -user has many gifs through categories

class User < ActiveRecord::Base
    has_many :categories
    has_many :gifs, through: :categories
end