class TopController < ApplicationController

  # ログインしていない場合はログイン画面へ
  before_action :authenticate_user!, :only => [:show, :index]

  def index

    if current_user.user_groups.blank? then
      # 初期ログイン時の処理
      create_individual_group
    else
      # 2回目以降の処理
      set_user_group_id
    end

    # 観光地の候補
    @items = Item.limit(20)
    # 投票中のアイテム
    @user_items = UserGroup.find(UserGroup.user_group_id).user_items.includes(:item)
    # 投票用のインスタンス
    @new_user_item = UserItem.new
    # ユーザの所属するグループ情報
    @user_groups = current_user.user_groups.includes(:group)

    # --- JSでも利用可能な変数 ----
    # 観光地の候補
    gon.items = Item.to_hash(@items, "id") # idでハッシュに変換
    # ユーザが投票中のidとアイテムのジオコード
    gon.user_items_geocodes = UserItem.extract_item_geocode(@user_items)
    # top画面の正面のitem_idを取得
    gon.current_item_id = 0

    # binding.pry
  end

  # ajax
  def create
    UserItem.create(user_item_params)
    # 追加したレコードのIDを取得
    @create_user_item_id = UserItem.where(user_item_params)[0].id
  end

  # ajax
  def destroy
    user_item = UserItem.find(params[:id])
    user_item.destroy
    @destroy_user_item_id = params[:id]
  end

  private
  def user_item_params
    params.require(:user_item).permit(:item_id).merge({:user_group_id => UserGroup.user_group_id})
  end

  def create_individual_group
    """
    個人グループを作成・ユーザとひも付け
    """
    Group.create(:group_name => "individual", :owner_user_id => current_user.id, :destination => "北海道")
    # ユーザとグループを紐付ける
    group_id = Group.where({:group_name => "individual", :owner_user_id => current_user.id})[0].id
    UserGroup.create(:user_id => current_user.id, :group_id => group_id)
    # ユーザ✕グループID取得・セット
    user_group_id = UserGroup.where({:user_id => current_user.id, :group_id => group_id})[0].id
    UserGroup.set_user_group_id(user_group_id)
  end

  def set_user_group_id
    """
    ユーザ✕グループIDをセット
    → 起動時：投稿の日付に基づいて選択
    → グループ変更時：対象のID (クエリから取得)
    """
    if params["id"].blank? then
      # 起動時
      user_groups = current_user.user_groups.includes(:user_items)
      UserGroup.get_current_user_group_id(user_groups)
    else
      # TODO : ユーザのチェックが必要
      UserGroup.set_user_group_id(params["id"])
    end
  end

end
