class UserGroup < ActiveRecord::Base

  belongs_to :user
  belongs_to :group
  has_many :user_items

  @@current_user_group = 0

  def self.get_current_user_group
    """
    現在ログイン中のユーザのグループを自動選択
    ログイン時のみtop_contollerで呼び出し
    """
  end

end
