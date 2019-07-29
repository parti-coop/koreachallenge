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

ActiveRecord::Schema.define(version: 2019_07_29_155307) do

  create_table "comments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "commentable_type", null: false
    t.bigint "commentable_id", null: false
    t.text "body"
    t.integer "likes_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "ideas", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "category", null: false
    t.string "title", null: false
    t.string "mode"
    t.string "team_name"
    t.text "motivation"
    t.text "summary"
    t.text "pt"
    t.text "desc"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "attachment"
    t.string "attachment_name"
    t.string "attachment_type"
    t.integer "attachment_size"
    t.datetime "submitted_at"
    t.index ["user_id"], name: "index_ideas_on_user_id", unique: true
  end

  create_table "images", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "alt"
    t.string "hint"
    t.string "file"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "likes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "likable_type", null: false
    t.bigint "likable_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["likable_type", "likable_id"], name: "index_likes_on_likable_type_and_likable_id"
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "members", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "idea_id"
    t.string "name"
    t.string "age"
    t.string "sex"
    t.string "org"
    t.string "address"
    t.string "tel"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["idea_id"], name: "index_members_on_idea_id"
  end

  create_table "notices", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "title", null: false
    t.text "body"
    t.integer "comments_count", default: 0
    t.integer "reads_count", default: 0
    t.integer "likes_count", default: 0
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_notices_on_user_id"
  end

  create_table "stories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "title", null: false
    t.text "body"
    t.string "image"
    t.integer "reads_count", default: 0
    t.integer "likes_count", default: 0
    t.integer "comments_count", default: 0
    t.bigint "user_id", null: false
    t.boolean "pin", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "attachment1"
    t.string "attachment1_name"
    t.string "attachment1_type"
    t.integer "attachment1_size"
    t.string "attachment2"
    t.string "attachment2_name"
    t.string "attachment2_type"
    t.integer "attachment2_size"
    t.string "attachment3"
    t.string "attachment3_name"
    t.string "attachment3_type"
    t.integer "attachment3_size"
    t.string "attachment4"
    t.string "attachment4_name"
    t.string "attachment4_type"
    t.integer "attachment4_size"
    t.string "attachment5"
    t.string "attachment5_name"
    t.string "attachment5_type"
    t.integer "attachment5_size"
    t.string "attachment6"
    t.string "attachment6_name"
    t.string "attachment6_type"
    t.integer "attachment6_size"
    t.string "attachment7"
    t.string "attachment7_name"
    t.string "attachment7_type"
    t.integer "attachment7_size"
    t.string "attachment8"
    t.string "attachment8_name"
    t.string "attachment8_type"
    t.integer "attachment8_size"
    t.string "attachment9"
    t.string "attachment9_name"
    t.string "attachment9_type"
    t.integer "attachment9_size"
    t.string "attachment10"
    t.string "attachment10_name"
    t.string "attachment10_type"
    t.integer "attachment10_size"
    t.index ["user_id"], name: "index_stories_on_user_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "email", default: ""
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false
    t.string "provider", null: false
    t.string "uid", null: false
    t.string "profile_image"
    t.string "name"
    t.boolean "confirmation_terms", default: false
    t.boolean "confirmation_privacy", default: false
    t.boolean "confirmation_mailing", default: false
    t.boolean "confirmation_offer", default: false
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
