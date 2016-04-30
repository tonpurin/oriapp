class UserGroup < ActiveRecord::Base

  belongs_to :user
  belongs_to :group
  has_many :user_items

  # ユーザ×グループID
  @@user_group_id = 0
  # ゲッタ
  def self.user_group_id
    return @@user_group_id
  end
  # セッタ
  def self.set_user_group_id(id)
    @@user_group_id = id
  end

  def self.get_current_user_group_id(user_groups)
    """
    現在ログイン中のユーザのグループを自動選択
    ログイン時のみtop_contollerで呼び出し

    :param UserGroup user_groups:
    current_userの所属グループ
    includesで選択アイテムが紐付いている

    :retrun: current_user_group_id:
    ユーザ×グループID
    """
    current_user_group_id = 0
    latest_date = Time.zone.local(0)

    user_groups.each do |ug|

      # 最近投票したグループを探索
      unless ug.user_items.blank? then
        last_selected_item_date = ug.user_items.order('updated_at DESC')[0]["updated_at"]
        if last_selected_item_date > latest_date then
          latest_date = last_selected_item_date
          current_user_group_id = ug.id
        end
      end
    end

    @@user_group_id = current_user_group_id
  end
end
