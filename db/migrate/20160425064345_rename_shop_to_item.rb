class RenameShopToItem < ActiveRecord::Migration
  def change
    rename_table :shops, :items #この行を追加！
  end
end
