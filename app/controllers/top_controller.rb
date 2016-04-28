class TopController < ApplicationController

  # ログインしていない場合はログイン画面へ
  before_action :authenticate_user!, :only => [:show, :index]

  def index
    # ユーザのグループを自動選択
    user_groups = current_user.user_groups.includes(:user_items)
    @current_user_group = UserGroup.get_current_user_group(user_groups)

    # 観光地の候補
    @items = Item.limit(20)
    # 投票中のアイテム
    @user_items = UserItem.all
    # 投票用のインスタンス
    @new_user_item = UserItem.new

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
    params.require(:user_item).permit(:user_group_id, :item_id)
  end

end
