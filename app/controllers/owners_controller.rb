class OwnersController < ApplicationController

  def index
    # 対象のgroupの投票を集約
    # 投票されたアイテム...includesが出来ない
    voted_items = Group.find(UserGroup.group_id(current_user.id)).user_items
    # 集計，得票数の多い順にソート，idと得票数のハッシュを取得
    voted_counts = voted_items.group(:item_id).order('count_item_id DESC').count(:item_id).to_a # 配列変換

    # 集計結果を使って並び替え
    @orderd_voted_items = convert_voted_item(voted_items, voted_counts)
    tmp = @orderd_voted_items.transpose # transposeで転地...作業用

    # 投票中のアイテムのID・ジオコード・ユーザ✕アイテムIDを配列で取得...[[ID], [Geo], [UserItemID]]
    gon.group_items_info = UserItem.extract_item_info(tmp[1])
    # 得票数も格納
    gon.group_items_info[3] = tmp[0]

    # 投票用のインスタンス
    @new_group_item = GroupItem.new

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
  def convert_voted_item(voted_items, voted_counts)
    """
    投票されたアイテムを得票数で並び替え,
    カウント数とレコードを要素とした配列を作成する
    """
    converted_voted_item = []
    voted_counts.each do |voted_count|
      item_id = voted_count[0]
      vote_count = voted_count[1]

      converted_voted_item << [vote_count, voted_items.where(:item_id => item_id)[0]]
    end
    return converted_voted_item
  end

  def group_item_params
    # 緯度経度の桁数調整
    lat = params.require(:group_item)['item_lat'].to_f.round(7)
    lng = params.require(:group_item)['item_lng'].to_f.round(7)
    params.require(:group_item).permit(:item_id, :item_name, :image_url, :item_url, :item_address).merge({:item_lat => lat, :item_lng => lng, :item_genre => 'hotel', :group_id => UserGroup.group_id(current_user.id)})
  end

end
