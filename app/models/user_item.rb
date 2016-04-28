class UserItem < ActiveRecord::Base

  belongs_to :user_group
  belongs_to :item

  def self.extract_item_geocode(user_items)
    """
    gon経由でJSに変数を渡すための変換
    user_itemsからitemのジオコードを抽出してハッシュで返す
    """
    item_geocodes = []
    user_items.each do |ui|
      lat = ui.item.item_lat
      lng = ui.item.item_lng
      item_geocodes << [lat, lng]
    end
    # BigDecimalオブジェクトが格納されるが，JSで丸め込まれる...
    return item_geocodes
  end

end
