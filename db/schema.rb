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

ActiveRecord::Schema.define(version: 20161109195502) do

  create_table "quotes", force: :cascade do |t|
    t.integer  "shipment_id"
    t.string   "name"
    t.integer  "price"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "quotes", ["shipment_id"], name: "index_quotes_on_shipment_id"

  create_table "shipments", force: :cascade do |t|
    t.string   "country",    default: "US"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.float    "weight"
    t.float    "length",     default: 11.0
    t.float    "width",      default: 8.5
    t.float    "height",     default: 5.5
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

end
