class AddVoteNumToGroupItems < ActiveRecord::Migration
  def change
    add_column :group_items, :vote_num, :integer
  end
end
