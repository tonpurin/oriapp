class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|

      t.string :group_name
      t.integer :owner
      t.string :destination
      t.timestamps
    end
  end
end
