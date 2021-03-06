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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130129060508) do

  create_table "animes", :force => true do |t|
    t.integer  "owner_id"
    t.string   "title"
    t.integer  "total_episode_number"
    t.text     "description"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.integer  "status"
  end

  create_table "cut_parts", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "episode_id"
    t.integer  "sort"
  end

  create_table "cuts", :force => true do |t|
    t.integer  "episode_id"
    t.string   "number"
    t.integer  "cut_part_id"
    t.string   "picture"
    t.text     "memo"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "episode_members", :force => true do |t|
    t.integer  "user_id"
    t.integer  "episode_id"
    t.integer  "role"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "episodes", :force => true do |t|
    t.integer  "director_id"
    t.integer  "episode_number"
    t.text     "title"
    t.text     "description"
    t.datetime "deadline"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "anime_id"
    t.integer  "status"
  end

  create_table "users", :force => true do |t|
    t.string   "login_id"
    t.string   "password"
    t.string   "mail_addr"
    t.string   "nick_name"
    t.string   "real_name"
    t.string   "phone_number"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.datetime "last_login"
    t.integer  "account_type"
    t.integer  "account_status"
    t.string   "twitter"
    t.string   "pixiv"
  end

end
