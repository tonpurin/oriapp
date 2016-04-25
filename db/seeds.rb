# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# csv読み込み
require "csv"

CSV.foreach('db/zyaran_scrap_geocode.csv') do |row|
  Shop.create(:shop_name => row[0], :rate => row[1], :shop_pref => row[2], :shop_genre => row[3], :image_url => row[4], :shop_zip => row[5], :shop_address => row[6], :shop_url => row[7], :shop_lat => row[8], :shop_lng => row[9])
end