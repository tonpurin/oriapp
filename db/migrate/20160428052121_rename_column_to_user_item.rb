class RenameColumnToUserItem < ActiveRecord::Migration
  def change
    rename_column :user_items, :user_id, :user_group_id
  end
end
