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

ActiveRecord::Schema.define(version: 20150430021241) do

  create_table "games", force: :cascade do |t|
    t.string   "name",                           limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "rating_type",                    limit: 255
    t.integer  "min_number_of_teams"
    t.integer  "max_number_of_teams"
    t.integer  "min_number_of_players_per_team"
    t.integer  "max_number_of_players_per_team"
    t.boolean  "allow_ties"
    t.string   "stream_url",                     limit: 255
    t.string   "motion_detected_title",          limit: 255
    t.string   "motion_absent_title",            limit: 255
    t.datetime "motion_active_at"
    t.integer  "player_id"
  end

  add_index "games", ["player_id"], name: "index_games_on_player_id"

  create_table "players", force: :cascade do |t|
    t.string   "name",                limit: 255,                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",               limit: 255
    t.string   "username",            limit: 255, default: "",    null: false
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                   default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",  limit: 255
    t.string   "last_sign_in_ip",     limit: 255
    t.boolean  "is_admin",                        default: false, null: false
  end

  add_index "players", ["username"], name: "index_players_on_username", unique: true

  create_table "players_teams", force: :cascade do |t|
    t.integer "player_id"
    t.integer "team_id"
  end

  create_table "rating_history_events", force: :cascade do |t|
    t.integer  "rating_id",           null: false
    t.integer  "value",               null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "trueskill_mean"
    t.float    "trueskill_deviation"
  end

  add_index "rating_history_events", ["rating_id"], name: "index_rating_history_events_on_rating_id"

  create_table "ratings", force: :cascade do |t|
    t.integer  "player_id",           null: false
    t.integer  "game_id",             null: false
    t.integer  "value",               null: false
    t.boolean  "pro",                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "trueskill_mean"
    t.float    "trueskill_deviation"
  end

  add_index "ratings", ["game_id"], name: "index_ratings_on_game_id"
  add_index "ratings", ["player_id"], name: "index_ratings_on_player_id"

  create_table "results", force: :cascade do |t|
    t.integer  "game_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "results", ["game_id"], name: "index_results_on_game_id"

  create_table "teams", force: :cascade do |t|
    t.integer  "rank"
    t.integer  "result_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "webhooks", force: :cascade do |t|
    t.string   "url",        null: false
    t.integer  "game_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "webhooks", ["game_id"], name: "index_webhooks_on_game_id"
  add_index "webhooks", ["url", "game_id"], name: "index_webhooks_on_url_and_game_id", unique: true

end
