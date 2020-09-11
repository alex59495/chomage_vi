# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_09_10_195350) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "documents", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "company"
    t.string "work"
    t.string "work_type"
    t.date "start_date"
    t.date "end_date"
    t.date "old_start_date"
    t.date "old_end_date"
    t.string "old_work"
    t.string "old_company"
    t.date "start_unemployment_at"
    t.bigint "info_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["info_id"], name: "index_documents_on_info_id"
  end

  create_table "infos", force: :cascade do |t|
    t.string "work"
    t.string "unemployment"
    t.integer "days_unemployment"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "jobs", force: :cascade do |t|
    t.string "company"
    t.string "work"
    t.date "start_at"
    t.date "end_at"
    t.bigint "info_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["info_id"], name: "index_jobs_on_info_id"
  end

  add_foreign_key "documents", "infos"
  add_foreign_key "jobs", "infos"
end
