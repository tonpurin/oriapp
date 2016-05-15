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
    gon.user_items_info = UserItem.extract_item_info(tmp[1])
    # 得票数も格納
    gon.user_items_info[3] = tmp[0]

    # binding.pry

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

end
