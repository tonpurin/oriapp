class UserGroup < ActiveRecord::Base

  belongs_to :user
  belongs_to :group
  has_many :user_items

  # ユーザIDとユーザ×グループIDのハッシュ
  @@current_user_group_ids = {}
  # ゲッタ
  def self.user_group_id(user_id)
    return @@current_user_group_ids[user_id]
  end
  # セッタ
  def self.set_user_group_id(user_id, user_group_id)
    @@current_user_group_ids[user_id] = user_group_id
  end

  # グループID
  def self.group_id(user_id)
    user_group_record = UserGroup.find(UserGroup.user_group_id(user_id))
    return user_group_record.group.id
  end

  # # ユーザ✕グループのオーナー
  # def self.user_group_owner
  #   user_group_record = UserGroup.find(@@user_group_id) ##
  #   return user_group_record.group.owner_user_id
  # end

  # # ユーザ✕グループのアバター
  # def self.user_group_avatar
  #   user_group_record = UserGroup.find(@@user_group_id) ##
  #   return user_group_record.group.avatar
  # end

  def self.select_user_group_id(user_id, user_groups)
    """
    現在ログイン中のユーザのグループを自動選択
    ログイン時のみtop_contollerで呼び出し

    :param UserGroup user_groups:
    current_userの所属グループ
    includesで選択アイテムが紐付いている

    :retrun: current_user_group_id:
    ユーザ×グループID
    """
    current_user_group_id = -1
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

    if current_user_group_id == -1 then
      # どのグループでも投稿していない場合
      return user_groups[0].id
    else
      return current_user_group_id
    end
  end
end
