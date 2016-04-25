class TopController < ApplicationController

  def index
    @items = Item.limit(20)
    # JSでも利用可能な変数
    # idでハッシュに変換
    gon.items = Item.to_hash(@items, "id")
  end

end
