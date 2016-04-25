class TopController < ApplicationController

  def index
    @items = Item.limit(20)
  end

end
