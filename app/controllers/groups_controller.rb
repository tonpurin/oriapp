class GroupsController < ApplicationController

  def new
    # binding.pry
    @new_group = Group.new
  end

  def create
    # グループ作成
    Group.create(group_params)
    group_id = Group.where(group_params)[0].id
    # ユーザとグループの結びつけ
    # オーナー
    UserGroup.create({:user_id => current_user.id, :group_id => group_id})
    # メンバー
    add_members = user_groups_params
    add_members.each{|key, member_obj|
      UserGroup.create({:user_id => member_obj['user_id'], :group_id => group_id})
    }
    # トップページにリダイレクト
    user_group_id = UserGroup.where({:user_id => current_user.id, :group_id => group_id})[0].id
    redirect_to controller: 'top', action: "index", id: user_group_id
  end

  private
  def group_params
    params.require(:group).permit(:group_name, :destination).merge({:owner_user_id => current_user.id})
  end

  def user_groups_params
    params.require(:group).require(:user_groups_attributes)
  end

end
