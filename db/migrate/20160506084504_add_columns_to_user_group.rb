class AddColumnsToUserGroup < ActiveRecord::Migration
  def change
    add_column :user_groups, :user_name, :string
  end
end
