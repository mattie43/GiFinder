# -gif belongs to user through category
# -gif belongs to category
class Gif < ActiveRecord::Base
    belongs_to :category
    # delegate :user, :to => :category, :allow_nil => true

    # in Gif class (class method)
    def search_giphy
        # search, find, display
        # user can save to category or share (or save then share)
    end

    # in Gif class (class method)
    def view_gif_of_the_day
        # retrieve and display
        # option to save to category or share
        # or return to selection screen
    end
end