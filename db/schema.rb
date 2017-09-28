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

ActiveRecord::Schema.define(version: 20170928063857) do

  create_table "genres", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "user_id",    limit: 4
  end

  create_table "genres_series", id: false, force: :cascade do |t|
    t.integer "genre_id",  limit: 4
    t.integer "series_id", limit: 4
  end

  add_index "genres_series", ["genre_id"], name: "index_genres_series_on_genre_id", using: :btree
  add_index "genres_series", ["series_id"], name: "index_genres_series_on_series_id", using: :btree

  create_table "genres_videos", id: false, force: :cascade do |t|
    t.integer "genre_id", limit: 4
    t.integer "video_id", limit: 4
  end

  add_index "genres_videos", ["genre_id"], name: "index_genres_videos_on_genre_id", using: :btree
  add_index "genres_videos", ["video_id"], name: "index_genres_videos_on_video_id", using: :btree

  create_table "series", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.text     "desc",       limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "user_id",    limit: 4
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "videos", force: :cascade do |t|
    t.string   "type",                 limit: 255
    t.string   "title",                limit: 255
    t.integer  "season",               limit: 4
    t.integer  "episode",              limit: 4
    t.text     "desc",                 limit: 65535
    t.date     "date"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "series_id",            limit: 4
    t.integer  "user_id",              limit: 4
    t.string   "content_file_name",    limit: 255
    t.string   "content_content_type", limit: 255
    t.integer  "content_file_size",    limit: 4
    t.datetime "content_updated_at"
    t.string   "content",              limit: 255
  end

end
