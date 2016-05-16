class OwnersController < ApplicationController

  def index

    group_id = UserGroup.group_id(current_user.id)

    # 投票結果を集約して保存
    aggregate(group_id)
    # GroupItemのレコードを投票数でソートして取り出す
    @owner_items = GroupItem.where(:group_id => group_id).order("vote_num DESC")
    # 投票用のインスタンス
    @new_group_item = GroupItem.new

    # --- JSでも利用可能な変数 ----
    # 投票中のアイテムのID・ジオコード・ユーザ✕アイテムIDを配列で取得...[[ID], [Geo], [GroupItemID], [VoteNum]]
    gon.group_items_info = GroupItem.extract_item_info(@owner_items)
  end

  def search
    # binding.pry
    lat = params[:lat].to_f
    lng = params[:lng].to_f
    radius = params[:radius].to_f
    count = params[:count].to_i

    # APIで周辺の宿泊施設をサーチ
    jaran_api = JaranAPI.new()
    #  経度，緯度の順で渡す...利用制限
    @url = "using test data" # APIをたていている場合はURLが格納
    # @hotels, @url = jaran_api.search_hotel(lng, lat, radius, count)
    @hotels = jaran_api.get_test_data
    # @hotels = []

    # ヒットのチェック
    if @hotels.empty? then
      # ヒットしなかった場合
      @empty_check = 1
    else
      # ヒットした場合
      @empty_check = 0
    end
  end

  def create
    new_group_item_record = GroupItem.create(group_item_params)
    # 追加したレコードの情報を取得
    @create_group_item_id = new_group_item_record.id
    @item_lat = new_group_item_record.item_lat
    @item_lng = new_group_item_record.item_lng
    @item_url = new_group_item_record.item_url
    @image_url = new_group_item_record.image_url
    @item_name = new_group_item_record.item_name
    @item_address = new_group_item_record.item_address
    @item_id = new_group_item_record.item_id
  end

  def destroy
    group_item = GroupItem.find(params[:id])
    group_item.destroy
    @destroy_group_item_id = params[:id]
  end

  private
  def aggregate(group_id)

    # 以前の記録を消去
    destroy_voted_items(group_id)

    # 対象のgroupの投票を集約
    # 投票されたアイテム...includesが出来ない
    voted_items = Group.find(group_id).user_items
    # 集計，得票数の多い順にソート，idと得票数のハッシュを取得
    voted_counts = voted_items.group(:item_id).order('count_item_id DESC').count(:item_id).to_a # 配列変換

    # 集計結果をGroupItemに保存
    save_voted_items(voted_items, voted_counts, group_id)
  end

  def destroy_voted_items(group_id)
    """
    レコードを消去
    """
    voted_items = GroupItem.where(:group_id => group_id)
    voted_items.each do |v_item|
      v_item.destroy()
    end
  end

  def save_voted_items(voted_items, voted_counts, group_id)
    """
    投票されたアイテムを得票数とともにGroupItemに保存
    """
    voted_counts.each do |voted_count|
      item_id = voted_count[0]
      vote_count = voted_count[1]

      voted_item = voted_items.where(:item_id => item_id)[0]

      # GroupItemに保存
      group_item_id = save_voted_items_to_groupitem(voted_item, voted_count[1], group_id)
    end
  end

  def save_voted_items_to_groupitem(voted_item, vote_count, group_id)
    """
    投票されたアイテムをGroupItemに保存
    """
    item = voted_item.item

    saved_item_info = {}
    saved_item_info[:group_id] = group_id
    saved_item_info[:item_id] = item.id
    saved_item_info[:item_name] = item.item_name
    saved_item_info[:item_address] = item.item_address
    saved_item_info[:item_genre] = "grume"
    saved_item_info[:image_url] = item.image_url
    saved_item_info[:item_url] = item.item_url
    saved_item_info[:item_lat] = item.item_lat
    saved_item_info[:item_lng] = item.item_lng
    saved_item_info[:vote_num] = vote_count

    group_item = GroupItem.create(saved_item_info)
  end

  def group_item_params
    # 緯度経度の桁数調整
    lat = params.require(:group_item)['item_lat'].to_f.round(7)
    lng = params.require(:group_item)['item_lng'].to_f.round(7)
    params.require(:group_item).permit(:item_id, :item_name, :image_url, :item_url, :item_address).merge({:item_lat => lat, :item_lng => lng, :item_genre => 'hotel', :group_id => UserGroup.group_id(current_user.id), :vote_num => -1})
  end

end
