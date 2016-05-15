class CreateGroupItems < ActiveRecord::Migration
  def change
    create_table :group_items do |t|

      t.integer :group_id
      t.integer :item_id
      t.string :item_name
      t.string :item_genre
      t.string :image_url
      t.string :item_url
      t.string :item_address
      t.decimal :item_lat, precision: 11, scale: 8
      t.decimal :item_lng, precision: 11, scale: 8
      t.timestamps
    end
  end
end
