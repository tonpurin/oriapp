# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160420095930) do

  create_table "shops", force: :cascade do |t|
    t.string  "shop_name",    limit: 255
    t.float   "rate",         limit: 24
    t.string  "shop_pref",    limit: 255
    t.string  "shop_genre",   limit: 255
    t.text    "image_url",    limit: 65535
    t.string  "shop_zip",     limit: 255
    t.string  "shop_address", limit: 255
    t.decimal "shop_lat",                   precision: 11, scale: 8
    t.decimal "shop_lng",                   precision: 11, scale: 8
    t.text    "shop_url",     limit: 65535
  end

end
