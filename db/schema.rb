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

ActiveRecord::Schema.define(version: 20140601025406) do

  create_table "pre_reqs", force: true do |t|
    t.integer  "preUnit_id"
    t.integer  "unit_id"
    t.integer  "group"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pre_reqs", ["preUnit_id"], name: "index_pre_reqs_on_preUnit_id", using: :btree
  add_index "pre_reqs", ["unit_id"], name: "index_pre_reqs_on_unit_id", using: :btree

  create_table "stream_units", force: true do |t|
    t.integer  "stream_id"
    t.integer  "unit_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

add_index "stream_units", ["stream_id"], name: "index_stream_units_on_stream_id", using: :btree
  add_index "stream_units", ["unit_id"], name: "index_stream_units_on_unit_id", using: :btree
  
  create_table "streams", force: true do |t|
    t.string   "streamName"
    t.string   "streamCode"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "units", force: true do |t|
    t.integer  "unitCode"
    t.string   "unitName"
    t.integer  "preUnit"
    t.integer  "creditPoints"
    t.integer  "semAvailable"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",            null: false
    t.string   "crypted_password", null: false
    t.string   "salt",             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
