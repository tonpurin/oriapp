class UserItem < ActiveRecord::Base

  belongs_to :user_group
  belongs_to :item

end
