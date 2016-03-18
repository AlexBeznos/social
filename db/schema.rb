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

ActiveRecord::Schema.define(version: 20160317135834) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "ahoy_events", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.uuid     "visit_id"
    t.integer  "user_id"
    t.string   "name"
    t.json     "properties"
    t.datetime "time"
  end

  add_index "ahoy_events", ["time"], name: "index_ahoy_events_on_time", using: :btree
  add_index "ahoy_events", ["user_id"], name: "index_ahoy_events_on_user_id", using: :btree
  add_index "ahoy_events", ["visit_id"], name: "index_ahoy_events_on_visit_id", using: :btree

  create_table "answers", force: true do |t|
    t.string   "content"
    t.integer  "poll_auth_id"
    t.integer  "number_of_selections", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "answers", ["poll_auth_id"], name: "index_answers_on_poll_auth_id", using: :btree

  create_table "auths", force: true do |t|
    t.string   "resource_type"
    t.integer  "resource_id"
    t.integer  "place_id"
    t.string   "redirect_url"
    t.boolean  "active",        default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "step",          default: 0
  end

  add_index "auths", ["place_id"], name: "index_auths_on_place_id", using: :btree
  add_index "auths", ["resource_id"], name: "index_auths_on_resource_id", using: :btree

  create_table "banners", force: true do |t|
    t.string   "name"
    t.integer  "number_of_views",      default: 0, null: false
    t.integer  "place_id"
    t.string   "content_file_name"
    t.string   "content_content_type"
    t.integer  "content_file_size"
    t.datetime "content_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "banners", ["place_id"], name: "index_banners_on_place_id", using: :btree

  create_table "customer_network_profiles", force: true do |t|
    t.integer  "social_network_id"
    t.integer  "customer_id"
    t.integer  "friends_count"
    t.string   "access_token"
    t.string   "access_token_secret"
    t.datetime "expiration_date"
    t.string   "url"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "customer_network_profiles", ["customer_id"], name: "index_customer_network_profiles_on_customer_id", using: :btree
  add_index "customer_network_profiles", ["social_network_id"], name: "index_customer_network_profiles_on_social_network_id", using: :btree
  add_index "customer_network_profiles", ["uid"], name: "index_customer_network_profiles_on_uid", using: :btree

  create_table "customer_reputations", force: true do |t|
    t.integer  "score",       default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "place_id"
    t.integer  "customer_id"
  end

  add_index "customer_reputations", ["customer_id"], name: "index_customer_reputations_on_customer_id", using: :btree
  add_index "customer_reputations", ["place_id"], name: "index_customer_reputations_on_place_id", using: :btree

  create_table "customer_visits", force: true do |t|
    t.integer  "customer_network_profile_id"
    t.integer  "place_id"
    t.integer  "customer_id"
    t.boolean  "by_password",                 default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "by_sms",                      default: false
  end

  add_index "customer_visits", ["created_at"], name: "index_customer_visits_on_created_at", using: :btree
  add_index "customer_visits", ["customer_id"], name: "index_customer_visits_on_customer_id", using: :btree
  add_index "customer_visits", ["customer_network_profile_id"], name: "index_customer_visits_on_customer_network_profile_id", using: :btree
  add_index "customer_visits", ["place_id"], name: "index_customer_visits_on_place_id", using: :btree

  create_table "customers", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "gender"
    t.string   "age"
    t.date     "birthday"
    t.string   "city"
    t.string   "country"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "social_network_id"
  end

  add_index "customers", ["social_network_id"], name: "index_customers_on_social_network_id", using: :btree

  create_table "facebook_auths", force: true do |t|
    t.text     "message"
    t.string   "message_url"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "gowifi_sms", force: true do |t|
    t.string   "phone"
    t.string   "code"
    t.integer  "place_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "gowifi_sms", ["place_id"], name: "index_gowifi_sms_on_place_id", using: :btree

  create_table "menu_items", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "price"
    t.integer  "place_id"
    t.integer  "items_count",        default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  add_index "menu_items", ["place_id"], name: "index_menu_items_on_place_id", using: :btree

  create_table "menu_items_orders", force: true do |t|
    t.integer "menu_item_id"
    t.integer "order_id"
  end

  add_index "menu_items_orders", ["menu_item_id"], name: "index_menu_items_orders_on_menu_item_id", using: :btree
  add_index "menu_items_orders", ["order_id"], name: "index_menu_items_orders_on_order_id", using: :btree

<<<<<<< HEAD
  create_table "notifications", force: true do |t|
    t.integer  "source_id"
    t.string   "source_type"
    t.integer  "user_id"
    t.string   "category"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "notifications", ["source_id", "source_type"], name: "index_notifications_on_source_id_and_source_type", using: :btree

=======
>>>>>>> bfa124f9b84268507750b736a1513bfc5a197556
  create_table "orders", force: true do |t|
    t.integer  "customer_id"
    t.integer  "place_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "orders", ["customer_id"], name: "index_orders_on_customer_id", using: :btree
  add_index "orders", ["place_id"], name: "index_orders_on_place_id", using: :btree

  create_table "password_auths", force: true do |t|
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "places", force: true do |t|
    t.string   "name"
    t.string   "slug"
    t.integer  "user_id"
    t.boolean  "active",                       default: false
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "wifi_username",                default: "P8uDratA"
    t.string   "wifi_password",                default: "Tac4edrU"
    t.string   "wifi_settings_link"
    t.boolean  "wifi_settings_link_not_fresh", default: true
    t.boolean  "stocks_active",                default: false
    t.string   "template",                     default: "default"
    t.integer  "score_amount",                 default: 0
    t.boolean  "loyalty_program",              default: false
    t.string   "city"
    t.boolean  "display_my_banners",           default: false
    t.boolean  "display_other_banners",        default: false
    t.float    "latitude"
    t.float    "longitude"
    t.string   "domen_url",                    default: "gofriends.com.ua"
    t.boolean  "demo",                         default: false
    t.string   "auth_default_lang"
    t.string   "ssid"
    t.boolean  "mfa",                          default: false
  end

  add_index "places", ["slug"], name: "index_places_on_slug", using: :btree
  add_index "places", ["user_id"], name: "index_places_on_user_id", using: :btree

  create_table "poll_auths", force: true do |t|
    t.text     "question"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", force: true do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "simple_auths", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sms_auths", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "social_network_icons", force: true do |t|
    t.integer  "place_id"
    t.string   "icon_file_name"
    t.string   "icon_content_type"
    t.integer  "icon_file_size"
    t.datetime "icon_updated_at"
    t.integer  "social_network_id"
    t.integer  "style_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "social_network_icons", ["place_id"], name: "index_social_network_icons_on_place_id", using: :btree
  add_index "social_network_icons", ["social_network_id"], name: "index_social_network_icons_on_social_network_id", using: :btree
  add_index "social_network_icons", ["style_id"], name: "index_social_network_icons_on_style_id", using: :btree

  create_table "social_networks", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "social_networks", ["name"], name: "index_social_networks_on_name", using: :btree

  create_table "stocks", force: true do |t|
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "place_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "day"
  end

  add_index "stocks", ["place_id"], name: "index_stocks_on_place_id", using: :btree

  create_table "styles", force: true do |t|
    t.text     "js"
    t.text     "js_min"
    t.text     "css"
    t.text     "css_min"
    t.string   "text_color"
    t.string   "greating_color"
    t.string   "background_file_name"
    t.string   "background_content_type"
    t.integer  "background_file_size"
    t.datetime "background_updated_at"
    t.integer  "place_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "styles", ["place_id"], name: "index_styles_on_place_id", using: :btree

  create_table "twitter_auths", force: true do |t|
    t.text     "message"
    t.string   "message_url"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                         null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone"
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
    t.integer  "user_id"
    t.string   "timezone"
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["last_request_at"], name: "index_users_on_last_request_at", using: :btree
  add_index "users", ["persistence_token"], name: "index_users_on_persistence_token", using: :btree

  create_table "visits", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.uuid     "visitor_id"
    t.string   "ip"
    t.text     "user_agent"
    t.text     "referrer"
    t.text     "landing_page"
    t.integer  "user_id"
    t.string   "referring_domain"
    t.string   "search_keyword"
    t.string   "browser"
    t.string   "os"
    t.string   "device_type"
    t.integer  "screen_height"
    t.integer  "screen_width"
    t.string   "country"
    t.string   "region"
    t.string   "city"
    t.string   "postal_code"
    t.decimal  "latitude"
    t.decimal  "longitude"
    t.string   "utm_source"
    t.string   "utm_medium"
    t.string   "utm_term"
    t.string   "utm_content"
    t.string   "utm_campaign"
    t.datetime "started_at"
  end

  add_index "visits", ["user_id"], name: "index_visits_on_user_id", using: :btree

  create_table "vkontakte_auths", force: true do |t|
    t.text     "message"
    t.string   "message_url"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
