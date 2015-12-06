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

ActiveRecord::Schema.define(version: 20151206155107) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "currencies", force: :cascade do |t|
    t.string   "name"
    t.string   "symbol"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "discounts", force: :cascade do |t|
    t.text     "description"
    t.integer  "merchant_id"
    t.decimal  "amount",        precision: 10, scale: 2
    t.boolean  "is_percentage"
    t.string   "user_profile"
    t.integer  "currency_id"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "discounts", ["currency_id"], name: "index_discounts_on_currency_id", using: :btree
  add_index "discounts", ["merchant_id"], name: "index_discounts_on_merchant_id", using: :btree

  create_table "merchants", force: :cascade do |t|
    t.string   "name"
    t.string   "location"
    t.string   "field"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "merchants", ["user_id"], name: "index_merchants_on_user_id", using: :btree

  create_table "messages", force: :cascade do |t|
    t.string   "from_num"
    t.string   "to_num"
    t.string   "text",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "referrals", force: :cascade do |t|
    t.integer  "old_user_id"
    t.integer  "new_user_id"
    t.integer  "transfer_id"
    t.integer  "merchant_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "referrals", ["merchant_id"], name: "index_referrals_on_merchant_id", using: :btree
  add_index "referrals", ["transfer_id"], name: "index_referrals_on_transfer_id", using: :btree

  create_table "sessions", force: :cascade do |t|
    t.string   "phone"
    t.text     "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transfers", force: :cascade do |t|
    t.integer  "from_user_id"
    t.integer  "to_user_id"
    t.decimal  "amount",              precision: 10, scale: 2
    t.integer  "discount_id"
    t.integer  "related_merchant_id"
    t.integer  "currency_id"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
  end

  add_index "transfers", ["currency_id"], name: "index_transfers_on_currency_id", using: :btree
  add_index "transfers", ["discount_id"], name: "index_transfers_on_discount_id", using: :btree
  add_index "transfers", ["from_user_id"], name: "index_transfers_on_from_user_id", using: :btree
  add_index "transfers", ["related_merchant_id"], name: "index_transfers_on_related_merchant_id", using: :btree
  add_index "transfers", ["to_user_id"], name: "index_transfers_on_to_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "gender"
    t.string   "location"
    t.string   "phone",                           null: false
    t.integer  "sign_in_count",       default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "currency_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.date     "birthday"
    t.integer  "default_currency_id"
    t.integer  "conversation_state",  default: 0
    t.string   "ssn"
  end

  add_index "users", ["currency_id"], name: "index_users_on_currency_id", using: :btree

  add_foreign_key "discounts", "currencies"
  add_foreign_key "discounts", "merchants"
  add_foreign_key "merchants", "users"
  add_foreign_key "referrals", "merchants"
  add_foreign_key "referrals", "transfers"
  add_foreign_key "referrals", "users", column: "new_user_id"
  add_foreign_key "referrals", "users", column: "old_user_id"
  add_foreign_key "transfers", "currencies"
  add_foreign_key "transfers", "discounts"
  add_foreign_key "transfers", "users", column: "from_user_id"
  add_foreign_key "transfers", "users", column: "to_user_id"
  add_foreign_key "users", "currencies"
  add_foreign_key "users", "currencies", column: "default_currency_id"
end
