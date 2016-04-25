class TopController < ApplicationController

  def index
    @shops = Shop.limit(20)
  end

end
