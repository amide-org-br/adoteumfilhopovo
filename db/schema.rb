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

ActiveRecord::Schema[8.0].define(version: 2025_09_25_003631) do
  create_table "adocaos", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "pna_id", null: false
    t.bigint "adotante_id", null: false
    t.date "data_adocao"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["adotante_id"], name: "index_adocaos_on_adotante_id"
    t.index ["pna_id"], name: "index_adocaos_on_pna_id"
  end

  create_table "adotantes", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "nome"
    t.string "estado"
    t.string "email"
    t.string "telefone"
    t.text "pedido_oracao"
    t.boolean "marcou_comprometimento"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "configs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "lote_adocao", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pnas", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "country_code_2"
    t.string "country"
    t.integer "people_id3"
    t.string "peop_name_in_country"
    t.integer "people_id1"
    t.string "affinity_bloc"
    t.integer "people_id2"
    t.string "people_cluster"
    t.string "primary_relig_in_people_cluster"
    t.string "country_code_3"
    t.string "primary_language_name"
    t.integer "population"
    t.boolean "in_window_10_40"
    t.text "location_in_country"
    t.string "primary_religion"
    t.integer "percent_evangelical"
    t.integer "percent_adherents"
    t.boolean "is_least_reached"
    t.integer "joshua_project_scale"
    t.integer "bible_status"
    t.boolean "has_jesus_movie_translated"
    t.boolean "has_audio_recordings"
    t.string "new_testament_online_code"
    t.boolean "is_indigenous"
    t.string "latitude"
    t.string "longitude"
    t.string "photo_url"
    t.string "map_url"
    t.string "flag_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "has_invalid_flag_url"
    t.boolean "has_invalid_photo_url"
    t.integer "total_adocoes", default: 0, null: false
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "adocaos", "adotantes"
  add_foreign_key "adocaos", "pnas"
end
