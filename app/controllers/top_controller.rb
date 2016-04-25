class TopController < ApplicationController

  def index
    @items = Item.limit(20)
    @user_item = UserItem.new
    # JSでも利用可能な変数
    # idでハッシュに変換
    gon.items = Item.to_hash(@items, "id")
    # top画面の正面のitem_idを取得
    gon.current_item_id = 0
  end

  def create
    UserItem.create(user_item_params)
  end

  private
  def user_item_params
    params.require(:user_item).permit(:user_id, :item_id)
  end

end
