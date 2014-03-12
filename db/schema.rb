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

ActiveRecord::Schema.define(version: 20130214221059) do

  create_table "client_apps", force: true do |t|
    t.string   "name"
    t.string   "app_type"
    t.integer  "entry_id"
    t.integer  "sibling_app_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "git_repo"
    t.string   "uid"
    t.string   "client_uid"
  end

  add_index "client_apps", ["entry_id"], name: "index_client_apps_on_entry_id"
  add_index "client_apps", ["sibling_app_id"], name: "index_client_apps_on_sibling_app_id"

  create_table "entries", force: true do |t|
    t.string   "name"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sibling_deploys", force: true do |t|
    t.integer  "sibling_id"
    t.integer  "instruction_id"
    t.boolean  "manual"
    t.string   "state"
    t.string   "git_repo"
    t.string   "heroku_repo"
    t.string   "heroku_app_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sibling_instructions", force: true do |t|
    t.string   "uid"
    t.string   "name"
    t.datetime "published_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "siblings", force: true do |t|
    t.string   "uid"
    t.string   "name"
    t.string   "git_repo"
    t.string   "heroku_repo"
    t.string   "heroku_app_name"
    t.boolean  "main_app"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
