class AddColumnsToGroup < ActiveRecord::Migration
  def change
    add_column :groups, :owner_user_name, :string
  end
end
