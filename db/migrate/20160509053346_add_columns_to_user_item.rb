class AddColumnsToUserItem < ActiveRecord::Migration
  def change
    add_column :user_items, :group_id, :integer
  end
end
