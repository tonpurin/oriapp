class RenameColumnToGroup < ActiveRecord::Migration
  def change
    rename_column :groups, :owner, :owner_user_id
  end
end
