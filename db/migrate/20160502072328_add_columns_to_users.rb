class AddColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :unique_name, :string
  end
end
