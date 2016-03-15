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

ActiveRecord::Schema.define(version: 20151217220124) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string   "street",     limit: 255, null: false
    t.string   "city",       limit: 255, null: false
    t.string   "state",      limit: 255, null: false
    t.string   "zip",        limit: 255, null: false
    t.decimal  "lat",                    null: false
    t.decimal  "lng",                    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "companies", force: :cascade do |t|
    t.string   "name",          limit: 255,                      null: false
    t.integer  "terms",                     default: 14,         null: false
    t.decimal  "credit_rate",               default: 0.0
    t.string   "code",          limit: 255
    t.string   "tag",                       default: "customer", null: false
    t.integer  "price_tier_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "companies", ["code"], name: "index_companies_on_code", unique: true, using: :btree
  add_index "companies", ["name"], name: "name", unique: true, using: :btree
  add_index "companies", ["price_tier_id"], name: "index_companies_on_price_tier_id", using: :btree
  add_index "companies", ["tag"], name: "index_companies_on_tag", using: :btree

  create_table "credit_note_items", force: :cascade do |t|
    t.integer  "credit_note_id",              null: false
    t.integer  "item_id",                null: false
    t.decimal  "quantity",   default: 0.0, null: false
    t.decimal  "unit_price", default: 0.0, null: false
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "credit_note_items", ["credit_note_id"], name: "index_credit_note_items_on_credit_note_id", using: :btree
  add_index "credit_note_items", ["item_id"], name: "index_items_on_item_id", using: :btree

  create_table "credit_notes", force: :cascade do |t|
    t.string   "xero_id",     limit: 255
    t.string   "credit_note_number", limit: 255
    t.integer  "credit_note_state"
    t.integer  "notifications_state"
    t.integer  "location_id",             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "date",                    null: false
  end

  add_index "credit_notes", ["xero_id"], name: "index_credit_notes_on_xero_id", unique: true, using: :btree
  add_index "credit_notes", ["credit_note_number"], name: "index_credit_notes_on_credit_note_number", unique: true, using: :btree
  add_index "credit_notes", ["location_id"], name: "index_credit_notes_on_location_id", using: :btree

  create_table "item_desires", force: :cascade do |t|
    t.integer  "location_id"
    t.integer  "item_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.boolean  "enabled",     default: false
  end

  add_index "item_desires", ["item_id"], name: "index_item_desires_on_item_id", using: :btree
  add_index "item_desires", ["location_id"], name: "index_item_desires_on_location_id", using: :btree

  create_table "item_levels", force: :cascade do |t|
    t.integer  "start",          default: 0, null: false
    t.integer  "returns",        default: 0, null: false
    t.integer  "total",                      null: false
    t.text     "notes"
    t.integer  "day_of_week",                null: false
    t.datetime "taken_at",                   null: false
    t.integer  "item_id",                    null: false
    t.integer  "location_id",                null: false
    t.integer  "user_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "route_visit_id"
  end

  add_index "item_levels", ["day_of_week"], name: "index_item_levels_on_day_of_week", using: :btree
  add_index "item_levels", ["item_id"], name: "index_item_levels_on_item_id", using: :btree
  add_index "item_levels", ["location_id"], name: "index_item_levels_on_location_id", using: :btree
  add_index "item_levels", ["route_visit_id"], name: "index_item_levels_on_route_visit_id", using: :btree
  add_index "item_levels", ["taken_at"], name: "index_item_levels_on_taken_at", using: :btree
  add_index "item_levels", ["user_id"], name: "index_item_levels_on_user_id", using: :btree

  create_table "item_prices", force: :cascade do |t|
    t.integer  "item_id",       null: false
    t.integer  "price_tier_id", null: false
    t.decimal  "price",         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "item_prices", ["item_id"], name: "index_item_prices_on_item_id", using: :btree
  add_index "item_prices", ["price_tier_id"], name: "index_item_prices_on_price_tier_id", using: :btree

  create_table "items", force: :cascade do |t|
    t.string   "xero_id",      limit: 255
    t.string   "name",         limit: 255,                            null: false
    t.string   "description",  limit: 255, default: "No description", null: false
    t.integer  "position"
    t.boolean  "is_sold",                  default: false,            null: false
    t.boolean  "is_purchased",             default: true,             null: false
    t.string   "tag",          limit: 255, default: "ingredient",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "items", ["is_purchased"], name: "index_items_on_is_purchased", using: :btree
  add_index "items", ["is_sold"], name: "index_items_on_is_sold", using: :btree
  add_index "items", ["name"], name: "index_items_on_name", unique: true, using: :btree
  add_index "items", ["tag"], name: "index_items_on_tag", using: :btree
  add_index "items", ["xero_id"], name: "index_items_on_xero_id", unique: true, using: :btree

  create_table "locations", force: :cascade do |t|
    t.string   "xero_id",       limit: 255
    t.integer  "company_id",                               null: false
    t.string   "name",          limit: 255,                null: false
    t.string   "code",          limit: 255,                null: false
    t.decimal  "delivery_rate",             default: 0.0
    t.boolean  "active",                    default: true, null: false
    t.integer  "address_id"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  add_index "locations", ["address_id"], name: "index_locations_on_address_id", using: :btree
  add_index "locations", ["company_id"], name: "index_locations_on_company_id", using: :btree
  add_index "locations", ["xero_id"], name: "index_locations_on_xero_id", unique: true, using: :btree

  create_table "order_items", force: :cascade do |t|
    t.integer  "order_id",                 null: false
    t.integer  "item_id",                  null: false
    t.decimal  "quantity",   default: 0.0, null: false
    t.decimal  "unit_price", default: 0.0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "order_items", ["item_id"], name: "index_order_items_on_item_id", using: :btree
  add_index "order_items", ["order_id"], name: "index_order_items_on_order_id", using: :btree

  create_table "orders", force: :cascade do |t|
    t.string   "xero_id",             limit: 255
    t.string   "order_number",        limit: 255
    t.integer  "order_state"
    t.integer  "notifications_state"
    t.string   "order_type",                 default: "sales-order", null: false
    t.integer  "location_id",                                        null: false
    t.integer  "route_visit_id"
    t.date     "delivery_date",                                      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.binary   "signature"
  end

  add_index "orders", ["xero_id"], name: "index_orders_on_xero_id", unique: true, using: :btree
  add_index "orders", ["order_number"], name: "index_orders_on_order_number", unique: true, using: :btree
  add_index "orders", ["order_state"], name: "index_orders_on_order_state", using: :btree
  add_index "orders", ["notifications_state"], name: "index_orders_on_notifications_state", using: :btree
  add_index "orders", ["location_id"], name: "index_orders_on_location_id", using: :btree
  add_index "orders", ["route_visit_id"], name: "index_orders_on_route_visit_id", using: :btree

  create_table "price_tiers", force: :cascade do |t|
    t.string   "name",        limit: 255, null: false
    t.string   "description", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "route_plans", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.date     "date"
    t.boolean  "template"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "route_plans", ["name"], name: "index_route_plans_on_name", unique: true, using: :btree
  add_index "route_plans", ["user_id"], name: "index_route_plans_on_user_id", using: :btree

  create_table "route_visits", force: :cascade do |t|
    t.integer  "route_plan_id",                  null: false
    t.text     "notes"
    t.integer  "arrive_at"
    t.string   "depart_at"
    t.integer  "position",                       null: false
    t.integer  "visit_window_id",                null: false
    t.string   "client_fingerprint", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "completed_at"
    t.boolean  "fullfilled"
  end

  add_index "route_visits", ["route_plan_id"], name: "index_route_visits_on_route_plan_id", using: :btree
  add_index "route_visits", ["visit_window_id"], name: "index_route_visits_on_visit_window_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string   "authentication_token",   limit: 255
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name",             limit: 255
    t.integer  "role"
    t.string   "last_name",              limit: 255
    t.string   "phone",                  limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "visit_days", force: :cascade do |t|
    t.integer  "location_id",                 null: false
    t.integer  "day",                         null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.boolean  "enabled",     default: false, null: false
  end

  add_index "visit_days", ["day"], name: "index_visit_days_on_day", using: :btree
  add_index "visit_days", ["location_id"], name: "index_visit_days_on_location_id", using: :btree

  create_table "visit_window_days", force: :cascade do |t|
    t.integer  "visit_window_id",                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "day",                             null: false
    t.boolean  "enabled",         default: false, null: false
  end

  add_index "visit_window_days", ["visit_window_id"], name: "index_visit_window_days_on_visit_window_id", using: :btree

  create_table "visit_windows", force: :cascade do |t|
    t.integer  "location_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "service",     null: false
    t.integer  "min",         null: false
    t.string   "max",         null: false
  end

  add_index "visit_windows", ["location_id"], name: "index_visit_windows_on_location_id", using: :btree

  add_foreign_key "companies", "price_tiers"
  add_foreign_key "credit_note_items", "credit_notes"
  add_foreign_key "credit_note_items", "items"
  add_foreign_key "credit_notes", "locations"
  add_foreign_key "item_desires", "items"
  add_foreign_key "item_desires", "locations"
  add_foreign_key "item_levels", "items"
  add_foreign_key "item_levels", "locations"
  add_foreign_key "item_levels", "route_visits"
  add_foreign_key "item_levels", "users"
  add_foreign_key "item_prices", "items"
  add_foreign_key "item_prices", "price_tiers"
  add_foreign_key "locations", "addresses"
  add_foreign_key "locations", "companies"
  add_foreign_key "order_items", "items"
  add_foreign_key "order_items", "orders"
  add_foreign_key "orders", "locations"
  add_foreign_key "orders", "route_visits"
  add_foreign_key "route_plans", "users"
  add_foreign_key "route_visits", "route_plans"
  add_foreign_key "route_visits", "visit_windows"
  add_foreign_key "visit_days", "locations"
  add_foreign_key "visit_window_days", "visit_windows"
  add_foreign_key "visit_windows", "locations"
end
