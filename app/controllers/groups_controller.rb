class GroupsController < ApplicationController

  def new
    # binding.pry
    @new_group = Group.new
  end

  # def show_group_member
  #   binding.pry
  # end

  def create
    # グループ作成
    #binding.pry
    new_group_record = Group.create(group_params)
    group_id = new_group_record.id

    # ユーザとグループの結びつけ
    # オーナー
    UserGroup.create({:user_id => current_user.id, :group_id => group_id, :user_name => current_user.unique_name})
    # メンバー
    unless user_groups_params.blank? then
      add_members = user_groups_params
      add_members.each{|key, member_obj|
        UserGroup.create({:user_id => User.where(:unique_name => member_obj['user_name'])[0].id, :group_id => group_id, :user_name => member_obj["user_name"]})
      }
    end

    # トップページにリダイレクト
    user_group_id = UserGroup.where({:user_id => current_user.id, :group_id => group_id})[0].id
    redirect_to controller: 'top', action: "index", id: user_group_id
  end

  def destroy
    # グループ消去
  end

  private
  def group_params
    params.require(:group).permit(:group_name, :destination, :avatar).merge({:owner_user_id => current_user.id, :owner_user_name => current_user.unique_name})
  end

  def user_groups_params
    # nilの要素に対してrequireするとerrorになる
    params.require(:group)["user_groups_attributes"]
  end

end
