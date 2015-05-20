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

ActiveRecord::Schema.define(version: 20150520211200) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "costumers", force: true do |t|
    t.string   "name"
    t.string   "s_name"
    t.string   "url"
    t.string   "uid"
    t.integer  "friends_count"
    t.string   "gender"
    t.string   "age"
    t.string   "b_date"
    t.string   "city"
    t.string   "country"
    t.integer  "social_network_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "costumers", ["social_network_id"], name: "index_costumers_on_social_network_id", using: :btree

  create_table "messages", force: true do |t|
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "redirect_link"
    t.text     "message"
    t.string   "message_link"
    t.integer  "place_id"
    t.boolean  "active"
    t.integer  "social_network_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "subscription"
    t.string   "subscription_uid"
  end

  add_index "messages", ["place_id"], name: "index_messages_on_place_id", using: :btree
  add_index "messages", ["social_network_id"], name: "index_messages_on_social_network_id", using: :btree

  create_table "places", force: true do |t|
    t.string   "name"
    t.string   "slug"
    t.integer  "user_id"
    t.boolean  "enter_by_password",          default: false
    t.string   "password"
    t.boolean  "active",                     default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "background_active"
    t.string   "mobile_image_file_name"
    t.string   "mobile_image_content_type"
    t.integer  "mobile_image_file_size"
    t.datetime "mobile_image_updated_at"
    t.string   "tablet_image_file_name"
    t.string   "tablet_image_content_type"
    t.integer  "tablet_image_file_size"
    t.datetime "tablet_image_updated_at"
    t.string   "desktop_image_file_name"
    t.string   "desktop_image_content_type"
    t.integer  "desktop_image_file_size"
    t.datetime "desktop_image_updated_at"
  end

  add_index "places", ["slug"], name: "index_places_on_slug", using: :btree
  add_index "places", ["user_id"], name: "index_places_on_user_id", using: :btree

  create_table "sessions", force: true do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "social_networks", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                         null: false
    t.string   "crypted_password",              null: false
    t.string   "password_salt",                 null: false
    t.string   "persistence_token",             null: false
    t.integer  "login_count",       default: 0, null: false
    t.datetime "last_request_at"
    t.datetime "last_login_at"
    t.datetime "current_login_at"
    t.string   "last_login_ip"
    t.string   "current_login_ip"
    t.integer  "group",             default: 0
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["last_request_at"], name: "index_users_on_last_request_at", using: :btree
  add_index "users", ["persistence_token"], name: "index_users_on_persistence_token", using: :btree

end
