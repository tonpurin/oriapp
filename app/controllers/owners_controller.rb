class OwnersController < ApplicationController

  def index
    # 対象のgroupの投票を集約
    # 投票されたアイテムのユニーク
    @voted_items = Group.find(UserGroup.group_id).user_items.group(:item_id).includes(:item)
    # 投票の多い順にidと得票数をハッシュでソート
    @vote_num = @voted_items.order('count_item_id DESC').count(:item_id)
  end

end
