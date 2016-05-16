class GroupItem < ActiveRecord::Base

  def self.extract_item_info(user_items)
    """
    gon経由でJSに変数を渡すための変換
    user_itemからアイテムのID, itemのジオコード, user_itemのidを抽出してハッシュで返す
    """
    item_ids = []
    item_geocodes = []
    user_item_ids = []

    user_items.each do |ui|

      item_ids << ui.item.id

      lat = ui.item.item_lat
      lng = ui.item.item_lng
      item_geocodes << [lat, lng]

      user_item_ids << ui.id
    end

    user_items_info = [item_ids, item_geocodes, user_item_ids]
    # BigDecimalオブジェクトが格納されるが，JSで丸め込まれる...
    return user_items_info
  end

end
