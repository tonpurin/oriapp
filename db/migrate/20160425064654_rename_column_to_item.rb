class RenameColumnToItem < ActiveRecord::Migration
  def change
    rename_column :items, :shop_name, :item_name
    rename_column :items, :shop_pref, :item_pref
    rename_column :items, :shop_genre, :item_genre
    rename_column :items, :shop_zip, :item_zip
    rename_column :items, :shop_address, :item_address
    rename_column :items, :shop_lat, :item_lat
    rename_column :items, :shop_lng, :item_lng
    rename_column :items, :shop_url, :item_url
  end
end
