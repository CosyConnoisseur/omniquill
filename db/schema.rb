# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_08_06_114347) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "campaigns", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "setting"
    t.text "synopsis"
    t.string "title"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_campaigns_on_user_id"
  end

  create_table "chapters", force: :cascade do |t|
    t.bigint "campaign_id", null: false
    t.datetime "created_at", null: false
    t.text "highlights"
    t.text "summary"
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["campaign_id"], name: "index_chapters_on_campaign_id"
  end

  create_table "characters", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.bigint "participation_id", null: false
    t.text "stats_summary"
    t.datetime "updated_at", null: false
    t.index ["participation_id"], name: "index_characters_on_participation_id"
  end

  create_table "notes", force: :cascade do |t|
    t.bigint "campaign_id", null: false
    t.datetime "created_at", null: false
    t.text "entry"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["campaign_id"], name: "index_notes_on_campaign_id"
    t.index ["user_id"], name: "index_notes_on_user_id"
  end

  create_table "participations", force: :cascade do |t|
    t.bigint "campaign_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["campaign_id"], name: "index_participations_on_campaign_id"
    t.index ["user_id"], name: "index_participations_on_user_id"
  end

  create_table "stickies", force: :cascade do |t|
    t.bigint "chapter_id", null: false
    t.datetime "created_at", null: false
    t.text "text"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["chapter_id"], name: "index_stickies_on_chapter_id"
    t.index ["user_id"], name: "index_stickies_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.string "username"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "campaigns", "users"
  add_foreign_key "chapters", "campaigns"
  add_foreign_key "characters", "participations"
  add_foreign_key "notes", "campaigns"
  add_foreign_key "notes", "users"
  add_foreign_key "participations", "campaigns"
  add_foreign_key "participations", "users"
  add_foreign_key "stickies", "chapters"
  add_foreign_key "stickies", "users"
end
