class AddStateToUserGroup < ActiveRecord::Migration
  def change
    add_column :user_groups, :state, :integer
  end
end
