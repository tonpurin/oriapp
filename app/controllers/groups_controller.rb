class GroupsController < ApplicationController

  def new
    @new_group = Group.new
    @new_user_group = UserGroup.new
  end

  def create
    binding.pry
    Group.create(group_params)
    redirect_to controller: 'groups', action: 'new'
  end

  private
  def group_params
    params.require(:group).permit(:group_name, :destination).merge({:owner_user_id => current_user.id})
  end

end
