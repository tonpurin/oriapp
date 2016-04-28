class UserGroup < ActiveRecord::Base

  belongs_to :user
  belongs_to :group
  has_many :user_items

  def self.get_current_user_group(user_groups)
    """
    現在ログイン中のユーザのグループを自動選択
    ログイン時のみtop_contollerで呼び出し

    :param UserGroup user_groups:
    current_userの所属グループ
    includesで選択アイテムが紐付いている
    """
    current_user_group = 0
    latest_date = Time.zone.local(0)

    user_groups.each do |ug|

      # 最近投票したグループを探索
      unless ug.user_items.blank? then
        last_selected_item_date = ug.user_items.order('updated_at DESC')[0]["updated_at"]
        if last_selected_item_date > latest_date then
          latest_date = last_selected_item_date
          current_user_group = ug.id
        end
      end

    end

    return current_user_group

  end

end
