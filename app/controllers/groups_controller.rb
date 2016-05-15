class GroupsController < ApplicationController

  def new
    # binding.pry
    @new_group = Group.new
  end

  def create
    # グループ作成
    new_group_record = Group.create(group_params)
    group_id = new_group_record.id

    # ユーザとグループの結びつけ
    # オーナー
    UserGroup.create({:user_id => current_user.id, :group_id => group_id, :user_name => current_user.unique_name, :state => 1})
    # メンバー
    unless user_groups_params.blank? then
      add_members = user_groups_params
      add_members.each{|key, member_obj|

        # DBに登録...stateは招待中
        new_group_member = UserGroup.create({:user_id => User.where(:unique_name => member_obj['user_name'])[0].id, :group_id => group_id, :user_name => member_obj["user_name"], :state => 0})

        # push通知
        Pusher["group_member_#{member_obj['user_name']}"].trigger('notification', {sender: current_user.unique_name, group_name: new_group_record.group_name, user_group_id: new_group_member.id}
        )
      }
    end

    # トップページにリダイレクト
    user_group_id = UserGroup.where({:user_id => current_user.id, :group_id => group_id})[0].id
    redirect_to controller: 'top', action: "index", id: user_group_id
  end

  def destroy
    # グループ消去
  end

  def consent
    # 参加する
    user_group = UserGroup.find(params[:id])

    # push通知
    owner_user_name = user_group.group.owner_user_name
    user_group_id = user_group.id
    Pusher["group_owner_#{owner_user_name}"].trigger('response', {group_id: user_group.group.id, user_group_id: user_group_id, answer: "consent"}
    )

    # stateを変更
    user_group.state = 1
    user_group.save()

    # リダイレクト
    redirect_to controller: 'top', action: "index", id: params[:id]
  end

  def object
    # 参加しない
    user_group = UserGroup.find(params[:id])

    #push通知
    owner_user_name = user_group.group.owner_user_name
    user_group_id = user_group.id
    Pusher["group_owner_#{owner_user_name}"].trigger('response', {group_id: user_group.group.id, user_group_id: user_group_id, answer: "object"}
    )

    # stateを変更
    user_group.state = -1
    user_group.save()

    # リダイレクト
    redirect_to root_path
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
