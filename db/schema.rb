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

ActiveRecord::Schema.define(version: 20180421184244) do

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
    t.string   "xero_id",              limit: 255
    t.string   "name",                 limit: 255,                 null: false
    t.integer  "terms",                            default: 14,    null: false
    t.boolean  "is_customer",                      default: true,  null: false
    t.boolean  "is_vendor",                        default: false, null: false
    t.integer  "price_tier_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "location_code_prefix", limit: 10,                  null: false
    t.integer  "active_state",                     default: 0,     null: false
    t.integer  "sync_state",                       default: 0,     null: false
  end

  add_index "companies", ["active_state"], name: "index_companies_on_active_state", using: :btree
  add_index "companies", ["is_customer"], name: "index_companies_on_is_customer", using: :btree
  add_index "companies", ["is_vendor"], name: "index_companies_on_is_vendor", using: :btree
  add_index "companies", ["location_code_prefix"], name: "index_companies_on_location_code_prefix", unique: true, using: :btree
  add_index "companies", ["name"], name: "name", unique: true, using: :btree
  add_index "companies", ["price_tier_id"], name: "index_companies_on_price_tier_id", using: :btree
  add_index "companies", ["sync_state"], name: "index_companies_on_sync_state", using: :btree
  add_index "companies", ["xero_id"], name: "index_companies_on_xero_id", unique: true, using: :btree

  create_table "credit_note_items", force: :cascade do |t|
    t.integer  "credit_note_id",               null: false
    t.integer  "item_id"
    t.string   "description"
    t.decimal  "quantity",       default: 0.0, null: false
    t.decimal  "unit_price",     default: 0.0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "credit_note_items", ["credit_note_id"], name: "index_credit_note_items_on_credit_note_id", using: :btree
  add_index "credit_note_items", ["item_id"], name: "index_items_on_item_id", using: :btree

  create_table "credit_notes", force: :cascade do |t|
    t.string   "xero_id",                     limit: 255
    t.string   "credit_note_number",          limit: 255
    t.date     "date",                                                null: false
    t.integer  "location_id",                                         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "submitted_at"
    t.integer  "sync_state",                              default: 0, null: false
    t.integer  "xero_financial_record_state",             default: 0, null: false
  end

  add_index "credit_notes", ["credit_note_number"], name: "index_credit_notes_on_credit_note_number", unique: true, using: :btree
  add_index "credit_notes", ["location_id"], name: "index_credit_notes_on_location_id", using: :btree
  add_index "credit_notes", ["sync_state"], name: "index_credit_notes_on_sync_state", using: :btree
  add_index "credit_notes", ["xero_financial_record_state"], name: "index_credit_notes_on_xero_financial_record_state", using: :btree
  add_index "credit_notes", ["xero_id"], name: "index_credit_notes_on_xero_id", unique: true, using: :btree

  create_table "fulfillments", force: :cascade do |t|
    t.integer  "route_visit_id",             null: false
    t.integer  "order_id"
    t.integer  "stock_id"
    t.integer  "credit_note_id"
    t.integer  "pod_id"
    t.integer  "delivery_state", default: 0, null: false
    t.datetime "submitted_at"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "fulfillments", ["credit_note_id"], name: "index_fulfillments_on_credit_note_id", using: :btree
  add_index "fulfillments", ["delivery_state"], name: "index_fulfillments_on_delivery_state", using: :btree
  add_index "fulfillments", ["order_id"], name: "index_fulfillments_on_order_id", using: :btree
  add_index "fulfillments", ["route_visit_id"], name: "index_fulfillments_on_route_visit_id", using: :btree
  add_index "fulfillments", ["stock_id"], name: "index_fulfillments_on_stock_id", using: :btree

  create_table "item_credit_rates", force: :cascade do |t|
    t.integer  "item_id",                   null: false
    t.integer  "location_id",               null: false
    t.decimal  "rate",        default: 0.0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "item_credit_rates", ["item_id"], name: "index_item_credit_rates_on_item_id", using: :btree
  add_index "item_credit_rates", ["location_id"], name: "index_item_credit_rates_on_location_id", using: :btree

  create_table "item_desires", force: :cascade do |t|
    t.integer  "location_id"
    t.integer  "item_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.boolean  "enabled",     default: false
  end

  add_index "item_desires", ["item_id"], name: "index_item_desires_on_item_id", using: :btree
  add_index "item_desires", ["location_id"], name: "index_item_desires_on_location_id", using: :btree

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
    t.string   "xero_id",         limit: 255
    t.string   "name",            limit: 255,                        null: false
    t.string   "code",            limit: 255,                        null: false
    t.string   "unit_of_measure", limit: 255
    t.string   "description"
    t.integer  "company_id"
    t.decimal  "position",                    default: 0.0
    t.decimal  "default_price",               default: 0.0,          null: false
    t.boolean  "is_sold",                     default: false,        null: false
    t.boolean  "is_purchased",                default: true,         null: false
    t.boolean  "active",                      default: true,         null: false
    t.string   "tag",             limit: 255, default: "ingredient", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sync_state",                  default: 0,            null: false
  end

  add_index "items", ["code"], name: "index_items_on_code", unique: true, using: :btree
  add_index "items", ["company_id"], name: "index_items_on_company_id", using: :btree
  add_index "items", ["is_purchased"], name: "index_items_on_is_purchased", using: :btree
  add_index "items", ["is_sold"], name: "index_items_on_is_sold", using: :btree
  add_index "items", ["name"], name: "index_items_on_name", using: :btree
  add_index "items", ["sync_state"], name: "index_items_on_sync_state", using: :btree
  add_index "items", ["tag"], name: "index_items_on_tag", using: :btree
  add_index "items", ["xero_id"], name: "index_items_on_xero_id", unique: true, using: :btree

  create_table "locations", force: :cascade do |t|
    t.integer  "company_id",                               null: false
    t.string   "name",          limit: 255
    t.decimal  "delivery_rate",             default: 0.0
    t.boolean  "active",                    default: true, null: false
    t.integer  "address_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "code",          limit: 10,                 null: false
    t.text     "note"
    t.text     "delivery_note"
  end

  add_index "locations", ["active"], name: "index_locations_on_active", using: :btree
  add_index "locations", ["address_id"], name: "index_locations_on_address_id", using: :btree
  add_index "locations", ["code"], name: "index_locations_on_code", unique: true, using: :btree
  add_index "locations", ["company_id"], name: "index_locations_on_company_id", using: :btree

  create_table "notification_rules", force: :cascade do |t|
    t.string   "first_name",   limit: 255
    t.string   "last_name",    limit: 255
    t.string   "email",        limit: 255,                 null: false
    t.integer  "location_id",                              null: false
    t.boolean  "enabled",                  default: true,  null: false
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.boolean  "wants_order",              default: false, null: false
    t.boolean  "wants_credit",             default: false, null: false
  end

  add_index "notification_rules", ["enabled"], name: "index_notification_rules_on_enabled", using: :btree
  add_index "notification_rules", ["location_id"], name: "index_notification_rules_on_location_id", using: :btree

  create_table "notifications", force: :cascade do |t|
    t.integer  "order_id"
    t.integer  "credit_note_id"
    t.integer  "notification_rule_id",             null: false
    t.datetime "processed_at"
    t.integer  "notification_state",   default: 0, null: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "renderer",                         null: false
    t.integer  "fulfillment_id"
  end

  add_index "notifications", ["credit_note_id"], name: "index_notifications_on_credit_note_id", using: :btree
  add_index "notifications", ["fulfillment_id"], name: "index_notifications_on_fulfillment_id", using: :btree
  add_index "notifications", ["notification_rule_id"], name: "index_notifications_on_notification_rule_id", using: :btree
  add_index "notifications", ["order_id"], name: "index_notifications_on_order_id", using: :btree

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

  create_table "order_template_days", force: :cascade do |t|
    t.integer  "order_template_id",                 null: false
    t.integer  "day",                               null: false
    t.boolean  "enabled",           default: false, null: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  add_index "order_template_days", ["day"], name: "index_order_template_days_on_day", using: :btree
  add_index "order_template_days", ["enabled"], name: "index_order_template_days_on_enabled", using: :btree
  add_index "order_template_days", ["order_template_id"], name: "index_order_template_days_on_order_template_id", using: :btree

  create_table "order_template_items", force: :cascade do |t|
    t.integer  "order_template_id",               null: false
    t.integer  "item_id",                         null: false
    t.decimal  "quantity",          default: 0.0, null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "order_template_items", ["item_id"], name: "index_order_template_items_on_item_id", using: :btree
  add_index "order_template_items", ["order_template_id"], name: "index_order_template_items_on_order_template_id", using: :btree

  create_table "order_templates", force: :cascade do |t|
    t.date     "start_date",              null: false
    t.integer  "frequency",   default: 1, null: false
    t.integer  "location_id",             null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "order_templates", ["frequency"], name: "index_order_templates_on_frequency", using: :btree
  add_index "order_templates", ["location_id"], name: "index_order_templates_on_location_id", using: :btree

  create_table "orders", force: :cascade do |t|
    t.string   "xero_id",                     limit: 255
    t.string   "order_number",                limit: 255
    t.string   "order_type",                              default: "sales-order", null: false
    t.integer  "location_id",                                                     null: false
    t.date     "delivery_date",                                                   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "submitted_at"
    t.decimal  "shipping",                                default: 0.0
    t.text     "internal_note"
    t.integer  "published_state",                         default: 0,             null: false
    t.integer  "sync_state",                              default: 0,             null: false
    t.integer  "xero_financial_record_state",             default: 0,             null: false
    t.string   "comment"
  end

  add_index "orders", ["location_id"], name: "index_orders_on_location_id", using: :btree
  add_index "orders", ["order_number"], name: "index_orders_on_order_number", unique: true, using: :btree
  add_index "orders", ["order_type"], name: "index_orders_on_order_type", using: :btree
  add_index "orders", ["published_state"], name: "index_orders_on_published_state", using: :btree
  add_index "orders", ["sync_state"], name: "index_orders_on_sync_state", using: :btree
  add_index "orders", ["xero_financial_record_state"], name: "index_orders_on_xero_financial_record_state", using: :btree
  add_index "orders", ["xero_id"], name: "index_orders_on_xero_id", unique: true, using: :btree

  create_table "pods", force: :cascade do |t|
    t.binary   "signature"
    t.string   "name",       limit: 255
    t.integer  "user_id"
    t.datetime "signed_at"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "price_tiers", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "route_plan_blueprint_slots", force: :cascade do |t|
    t.integer  "route_plan_blueprint_id", null: false
    t.integer  "address_id",              null: false
    t.decimal  "position",                null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "route_plan_blueprints", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "route_plan_blueprints", ["name"], name: "index_route_plan_blueprints_on_name", unique: true, using: :btree

  create_table "route_plans", force: :cascade do |t|
    t.integer  "user_id"
    t.date     "date"
    t.integer  "published_state", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "route_plans", ["date"], name: "index_route_plans_on_date", using: :btree
  add_index "route_plans", ["published_state"], name: "index_route_plans_on_published_state", using: :btree
  add_index "route_plans", ["user_id"], name: "index_route_plans_on_user_id", using: :btree

  create_table "route_visits", force: :cascade do |t|
    t.integer  "address_id",                      null: false
    t.integer  "route_plan_id"
    t.integer  "route_visit_state", default: 0,   null: false
    t.date     "date",                            null: false
    t.decimal  "position",          default: 0.0, null: false
    t.datetime "completed_at"
    t.integer  "arrive_at"
    t.string   "depart_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "route_visits", ["address_id"], name: "index_route_visits_on_address_id", using: :btree
  add_index "route_visits", ["date"], name: "index_route_visits_on_date", using: :btree
  add_index "route_visits", ["route_plan_id"], name: "index_route_visits_on_route_plan_id", using: :btree
  add_index "route_visits", ["route_visit_state"], name: "index_route_visits_on_route_visit_state", using: :btree

  create_table "stock_levels", force: :cascade do |t|
    t.integer  "starting",       default: 0, null: false
    t.integer  "returns",        default: 0, null: false
    t.integer  "item_id",                    null: false
    t.integer  "stock_id",                   null: false
    t.integer  "tracking_state", default: 0, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "stock_levels", ["item_id"], name: "index_stock_levels_on_item_id", using: :btree
  add_index "stock_levels", ["stock_id"], name: "index_stock_levels_on_stock_id", using: :btree
  add_index "stock_levels", ["tracking_state"], name: "index_stock_levels_on_tracking_state", using: :btree

  create_table "stocks", force: :cascade do |t|
    t.integer  "day_of_week"
    t.datetime "taken_at"
    t.integer  "location_id", null: false
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "stocks", ["day_of_week"], name: "index_stocks_on_day_of_week", using: :btree
  add_index "stocks", ["location_id"], name: "index_stocks_on_location_id", using: :btree
  add_index "stocks", ["taken_at"], name: "index_stocks_on_taken_at", using: :btree
  add_index "stocks", ["user_id"], name: "index_stocks_on_user_id", using: :btree

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
  add_index "users", ["role"], name: "index_users_on_role", using: :btree

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
    t.integer  "address_id", null: false
    t.integer  "min",        null: false
    t.integer  "max",        null: false
    t.integer  "service",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "visit_windows", ["address_id"], name: "index_visit_windows_on_address_id", using: :btree

  add_foreign_key "companies", "price_tiers"
  add_foreign_key "credit_note_items", "credit_notes"
  add_foreign_key "credit_note_items", "items"
  add_foreign_key "credit_notes", "locations"
  add_foreign_key "fulfillments", "credit_notes"
  add_foreign_key "fulfillments", "orders"
  add_foreign_key "fulfillments", "pods"
  add_foreign_key "fulfillments", "route_visits"
  add_foreign_key "fulfillments", "stocks"
  add_foreign_key "item_credit_rates", "items"
  add_foreign_key "item_credit_rates", "locations"
  add_foreign_key "item_desires", "items"
  add_foreign_key "item_desires", "locations"
  add_foreign_key "item_prices", "items"
  add_foreign_key "item_prices", "price_tiers"
  add_foreign_key "items", "companies"
  add_foreign_key "locations", "addresses"
  add_foreign_key "locations", "companies"
  add_foreign_key "notification_rules", "locations"
  add_foreign_key "notifications", "credit_notes"
  add_foreign_key "notifications", "fulfillments"
  add_foreign_key "notifications", "notification_rules"
  add_foreign_key "notifications", "orders"
  add_foreign_key "order_items", "items"
  add_foreign_key "order_items", "orders"
  add_foreign_key "order_template_days", "order_templates"
  add_foreign_key "order_template_items", "items"
  add_foreign_key "order_template_items", "order_templates"
  add_foreign_key "order_templates", "locations"
  add_foreign_key "orders", "locations"
  add_foreign_key "pods", "users"
  add_foreign_key "route_plan_blueprint_slots", "addresses"
  add_foreign_key "route_plan_blueprint_slots", "route_plan_blueprints"
  add_foreign_key "route_plan_blueprints", "users"
  add_foreign_key "route_plans", "users"
  add_foreign_key "route_visits", "addresses"
  add_foreign_key "route_visits", "route_plans"
  add_foreign_key "stock_levels", "items"
  add_foreign_key "stock_levels", "stocks"
  add_foreign_key "stocks", "locations"
  add_foreign_key "stocks", "users"
  add_foreign_key "visit_days", "locations"
  add_foreign_key "visit_window_days", "visit_windows"
  add_foreign_key "visit_windows", "addresses"
end
