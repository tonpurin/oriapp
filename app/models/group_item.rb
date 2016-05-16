class GroupItem < ActiveRecord::Base

  def self.extract_item_info(group_items)
    """
    gon経由でJSに変数を渡すための変換
    group_itemからアイテムのID, itemのジオコード, group_itemのid, vote_numを抽出してハッシュで返す
    """
    item_ids = []
    item_geocodes = []
    group_item_ids = []
    vote_nums = []

    group_items.each do |gi|

      item_ids << gi.item_id

      lat = gi.item_lat
      lng = gi.item_lng
      item_geocodes << [lat, lng]

      group_item_ids << gi.id

      vote_nums << gi.vote_num
    end

    group_items_info = [item_ids, item_geocodes, group_item_ids, vote_nums]
    # BigDecimalオブジェクトが格納されるが，JSで丸め込まれる...
    return group_items_info
  end

end
