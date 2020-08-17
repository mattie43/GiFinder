class CreateGifs < ActiveRecord::Migration[6.0]
    def change
        create_table :gifs do |t|
            t.integer :category_id
            t.string :link
            t.string :nickname
        end
    end
end