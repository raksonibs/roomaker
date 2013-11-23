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

ActiveRecord::Schema.define(version: 20131123183657) do

  create_table "acceptedtasks", force: true do |t|
    t.string   "text"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "group"
    t.integer  "completer_id"
  end

  create_table "completedtasks", force: true do |t|
    t.string   "text"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "completer_id"
    t.string   "group"
  end

  create_table "currenttasks", force: true do |t|
    t.string   "text"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "completer_id"
    t.string   "group"
    t.integer  "verified"
  end

  create_table "groups", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "groups_users", id: false, force: true do |t|
    t.integer "group_id"
    t.integer "user_id"
  end

  create_table "incompletetasks", force: true do |t|
    t.string   "text"
    t.integer  "user_id"
    t.integer  "completer_id"
    t.string   "group"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nods", force: true do |t|
    t.integer  "pendingtask_id"
    t.integer  "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "nos", force: true do |t|
    t.integer  "pendingtask_id"
    t.integer  "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "pendingtasks", force: true do |t|
    t.string   "text"
    t.integer  "assignee_id"
    t.string   "voter_ids"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "points"
    t.integer  "threshold"
    t.string   "group"
    t.integer  "negthreshold"
    t.integer  "filler_id"
  end

  create_table "pendingtasks_users", force: true do |t|
    t.integer "pendingtask_id"
    t.integer "user_id"
  end

  create_table "pendingvotes", force: true do |t|
    t.string   "text"
    t.integer  "pendingtask_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", force: true do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at"

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "provider"
    t.integer  "uid"
    t.string   "fname"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.integer  "group_id"
    t.integer  "pendingtask_id"
  end

  create_table "yes", force: true do |t|
    t.integer  "pendingtask_id"
    t.integer  "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
