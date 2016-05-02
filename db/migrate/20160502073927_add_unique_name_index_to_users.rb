class AddUniqueNameIndexToUsers < ActiveRecord::Migration
  def change
    add_index :users, :unique_name, unique: true
  end
end
