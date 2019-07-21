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

ActiveRecord::Schema.define(version: 2019_07_21_024307) do

  create_table "ideas", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "category", null: false
    t.string "title", null: false
    t.string "mode"
    t.integer "team_member_count"
    t.string "team_name"
    t.string "planner_name"
    t.string "planner_age"
    t.string "planner_sex"
    t.string "planner_org"
    t.string "planner_address"
    t.string "planner_tel"
    t.string "planner_email"
    t.text "motivation"
    t.text "summary"
    t.text "pt"
    t.text "desc"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "attachment"
    t.string "attachment_name"
    t.string "attachment_type", null: false
    t.integer "attachment_size", null: false
    t.datetime "submitted_at"
    t.index ["user_id"], name: "index_ideas_on_user_id"
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
    t.index ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
