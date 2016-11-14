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

ActiveRecord::Schema.define(version: 20161110211107) do

  create_table "packages", force: :cascade do |t|
    t.float    "weight"
    t.string   "destination_zip"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "requests", force: :cascade do |t|
    t.string   "verb"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "body"
  end

  create_table "responses", force: :cascade do |t|
    t.string   "content_type"
    t.string   "JSON_hash"
    t.string   "status_code"
    t.string   "request_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

end
