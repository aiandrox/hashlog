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

ActiveRecord::Schema.define(version: 2020_04_09_115515) do

  create_table "authentications", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "provider", null: false
    t.string "uid", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider", "uid"], name: "index_authentications_on_provider_and_uid"
    t.index ["user_id"], name: "index_authentications_on_user_id"
  end

  create_table "registered_tags", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "tweeted_day_count", default: 0, null: false
    t.integer "privacy", default: 0, null: false
    t.integer "remind_day", default: 0, null: false
    t.datetime "first_tweeted_at"
    t.datetime "last_tweeted_at"
    t.index ["tag_id"], name: "index_registered_tags_on_tag_id"
    t.index ["user_id"], name: "index_registered_tags_on_user_id"
  end

  create_table "tags", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tweets", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "registered_tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "oembed", null: false
    t.datetime "tweeted_at", null: false
    t.index ["registered_tag_id"], name: "index_tweets_on_registered_tag_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "twitter_id", null: false
    t.string "uuid", null: false
    t.string "name", null: false
    t.text "description"
    t.integer "privacy", default: 0, null: false
    t.integer "role", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "screen_name", null: false
    t.index ["twitter_id"], name: "index_users_on_twitter_id", unique: true
  end

  add_foreign_key "registered_tags", "tags"
  add_foreign_key "registered_tags", "users"
  add_foreign_key "tweets", "registered_tags"
end
