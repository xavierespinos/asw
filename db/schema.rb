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

ActiveRecord::Schema.define(version: 2020_05_07_192949) do

  create_table "comentaris", force: :cascade do |t|
    t.string "text", null: false
    t.integer "contribucion_id", null: false
    t.integer "comentari_id", default: 0, null: false
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "commentable_type"
    t.integer "commentable_id"
    t.integer "points", default: 0
    t.index ["commentable_type", "commentable_id"], name: "index_comentaris_on_commentable_type_and_commentable_id"
  end

  create_table "comentaris_voteds", force: :cascade do |t|
    t.integer "uid"
    t.integer "comentari"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "contribucions", force: :cascade do |t|
    t.integer "user_id"
    t.text "title"
    t.text "url"
    t.text "text"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "points", default: 0
    t.string "tipo"
    t.index ["user_id", "created_at"], name: "index_contribucions_on_user_id_and_created_at"
  end

  create_table "contribucions_voteds", force: :cascade do |t|
    t.integer "user"
    t.integer "contribucion"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "provider"
    t.string "uid"
    t.string "description"
    t.string "apitoken"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
