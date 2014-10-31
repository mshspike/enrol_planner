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

ActiveRecord::Schema.define(version: 20141009113546) do

  create_table "pre_req_groups", force: true do |t|
    t.integer  "unit_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pre_req_groups", ["unit_id"], name: "index_pre_req_groups_on_unit_id", using: :btree

  create_table "pre_reqs", force: true do |t|
    t.integer  "pre_req_group_id"
    t.integer  "unit_id"
    t.string   "preUnit_code"    # Task EPW-28 - Changed to string type
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pre_reqs", ["unit_id"], name: "index_pre_reqs_on_unit_id", using: :btree

  create_table "stream_units", force: true do |t|
    t.integer  "stream_id"
    t.integer  "unit_id"
    t.integer  "plannedYear"
    t.integer  "plannedSemester"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "streams", force: true do |t|
    t.string   "streamCode"    # Task EPW-28 - Changed to string type
    t.string   "streamName"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "units", force: true do |t|
    t.string   "unitCode"    # Task EPW-28 - Changed to string type
    t.string   "unitName"
    t.string   "preUnit"
    t.integer  "semAvailable"
    t.float    "creditPoints"
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
