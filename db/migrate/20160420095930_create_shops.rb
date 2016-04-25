class CreateShops < ActiveRecord::Migration
  def change
    create_table :shops do |t|

      t.string :shop_name
      t.float :rate
      t.string :shop_pref
      t.string :shop_genre
      t.text :image_url
      t.string :shop_zip
      t.string :shop_address
      t.decimal :shop_lat, precision: 11, scale: 8
      t.decimal :shop_lng, precision: 11, scale: 8
      t.text :shop_url
      # t.timestamps null: false
    end
  end
end
