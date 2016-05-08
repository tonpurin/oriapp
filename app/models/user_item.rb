class UserItem < ActiveRecord::Base

  belongs_to :user_group
  belongs_to :item

  def self.extract_item_info(user_items)
    """
    gon経由でJSに変数を渡すための変換
    user_itemからアイテムのIDを抽出してハッシュで返す
    user_itemsからuser_itemのidとitemのジオコードを抽出してハッシュで返す
    """
    item_geocodes = []
    item_ids = []
    user_items.each do |ui|

      item_ids << ui.item.id

      lat = ui.item.item_lat
      lng = ui.item.item_lng
      uset_item_id = ui.id
      item_geocodes << [lat, lng, uset_item_id]
    end
    # BigDecimalオブジェクトが格納されるが，JSで丸め込まれる...
    return item_ids, item_geocodes
  end

end
