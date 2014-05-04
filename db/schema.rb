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

ActiveRecord::Schema.define(version: 20140504001804) do

  create_table "courses", force: true do |t|
    t.string   "courseName"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "courseCode"
  end

  create_table "pre_req", primary_key: "pCode", force: true do |t|
    t.string "pName", limit: 100
  end

  create_table "pre_reqs", force: true do |t|
    t.integer  "preUnit_id"
    t.integer  "unit_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pre_reqs", ["preUnit_id"], name: "index_pre_reqs_on_preUnit_id", using: :btree
  add_index "pre_reqs", ["unit_id"], name: "index_pre_reqs_on_unit_id", using: :btree

  create_table "stream", primary_key: "sCode", force: true do |t|
    t.string "sName", limit: 100
  end

  create_table "stream_unit", id: false, force: true do |t|
    t.integer "sCode",    null: false
    t.integer "uCode",    null: false
    t.integer "year"
    t.integer "semester"
  end

  add_index "stream_unit", ["sCode"], name: "FK_01_idx", using: :btree
  add_index "stream_unit", ["uCode"], name: "FK_02_idx", using: :btree

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
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "unit", primary_key: "uCode", force: true do |t|
    t.string  "uName",        limit: 100
    t.integer "creditPoints"
    t.integer "semAvail"
    t.string  "type",         limit: 45
    t.string  "handbook",     limit: 100
  end

  create_table "unit_pre_reqs", force: true do |t|
    t.integer  "uCode"
    t.integer  "pCode"
    t.string   "option"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "units", force: true do |t|
    t.integer  "unitCode"
    t.string   "unitName"
    t.boolean  "semOne"
    t.boolean  "semTwo"
    t.integer  "preUnit"
    t.integer  "creditPoints"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "staffID"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
