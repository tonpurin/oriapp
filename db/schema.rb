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

ActiveRecord::Schema.define(version: 20160516024647) do

  create_table "group_items", force: :cascade do |t|
    t.integer  "group_id",     limit: 4
    t.integer  "item_id",      limit: 4
    t.string   "item_name",    limit: 255
    t.string   "item_genre",   limit: 255
    t.string   "image_url",    limit: 255
    t.string   "item_url",     limit: 255
    t.string   "item_address", limit: 255
    t.decimal  "item_lat",                 precision: 11, scale: 8
    t.decimal  "item_lng",                 precision: 11, scale: 8
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "vote_num",     limit: 4
  end

  create_table "groups", force: :cascade do |t|
    t.string   "group_name",          limit: 255
    t.integer  "owner_user_id",       limit: 4
    t.string   "destination",         limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_file_name",    limit: 255
    t.string   "avatar_content_type", limit: 255
    t.integer  "avatar_file_size",    limit: 4
    t.datetime "avatar_updated_at"
    t.string   "owner_user_name",     limit: 255
  end

  create_table "items", force: :cascade do |t|
    t.string  "item_name",    limit: 255
    t.float   "rate",         limit: 24
    t.string  "item_pref",    limit: 255
    t.string  "item_genre",   limit: 255
    t.text    "image_url",    limit: 65535
    t.string  "item_zip",     limit: 255
    t.string  "item_address", limit: 255
    t.decimal "item_lat",                   precision: 11, scale: 8
    t.decimal "item_lng",                   precision: 11, scale: 8
    t.text    "item_url",     limit: 65535
  end

  create_table "user_groups", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "group_id",   limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "user_name",  limit: 255
    t.integer  "state",      limit: 4
  end

  create_table "user_items", force: :cascade do |t|
    t.integer  "user_group_id", limit: 4
    t.integer  "item_id",       limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "group_id",      limit: 4
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "unique_name",            limit: 255
    t.string   "avatar_file_name",       limit: 255
    t.string   "avatar_content_type",    limit: 255
    t.integer  "avatar_file_size",       limit: 4
    t.datetime "avatar_updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unique_name"], name: "index_users_on_unique_name", unique: true, using: :btree

end
