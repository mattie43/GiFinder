# -gif belongs to user through category
# -gif belongs to category
class Gif < ActiveRecord::Base
    belongs_to :category
    # delegate :user, :to => :category, :allow_nil => true
end