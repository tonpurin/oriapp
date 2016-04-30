class TopController < ApplicationController

  # ログインしていない場合はログイン画面へ
  before_action :authenticate_user!, :only => [:show, :index]

  def index
    # ユーザの所属するグループ情報
    @user_groups = current_user.user_groups.includes(:group)
    # ユーザのグループを選択
    if params["id"].blank? then
      # 起動時は最新の投稿から判断
      user_group_items = current_user.user_groups.includes(:user_items)
      UserGroup.get_current_user_group_id(user_group_items)
    else
      # ユーザのチェックが必要
      UserGroup.set_user_group_id(params["id"])
    end

    # 観光地の候補
    @items = Item.limit(20)
    # 投票中のアイテム
    @user_items = UserGroup.find(UserGroup.user_group_id).user_items.includes(:item)
    # 投票用のインスタンス
    @new_user_item = UserItem.new

    # --- JSでも利用可能な変数 ----
    # 観光地の候補
    gon.items = Item.to_hash(@items, "id") # idでハッシュに変換
    # ユーザが投票中のidとアイテムのジオコード
    gon.user_items_geocodes = UserItem.extract_item_geocode(@user_items)
    # top画面の正面のitem_idを取得
    gon.current_item_id = 0

  end

  def create
    UserItem.create(user_item_params)
    # 追加したレコードのIDを取得
    @create_user_item_id = UserItem.where(user_item_params)[0].id
  end

  def destroy
    user_item = UserItem.find(params[:id])
    user_item.destroy
    @destroy_user_item_id = params[:id]
  end

  private
  def user_item_params
    params.require(:user_item).permit(:item_id).merge({:user_group_id => UserGroup.user_group_id})
  end

end
