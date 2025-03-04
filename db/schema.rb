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

ActiveRecord::Schema[8.0].define(version: 2025_02_16_220730) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "artists", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.boolean "emailVerified"
    t.string "password_digest"
    t.string "fullName"
    t.string "profilePhotoUrl"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "listeners", force: :cascade do |t|
    t.string "username", null: false
    t.string "email", null: false
    t.boolean "emailVerified"
    t.string "password_digest", null: false
    t.string "profilePhotoUrl"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "listening_histories", force: :cascade do |t|
    t.bigint "listener_id", null: false
    t.bigint "music_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["listener_id", "music_id"], name: "index_listening_histories_on_listener_id_and_music_id"
  end

  create_table "musics", force: :cascade do |t|
    t.bigint "artist_id", null: false
    t.string "title", null: false
    t.string "mp3link", null: false
    t.string "details"
    t.string "genre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["artist_id"], name: "index_musics_on_artist_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.bigint "listener_id", null: false
    t.bigint "artist_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["listener_id", "artist_id"], name: "index_subscriptions_on_listener_id_and_artist_id"
  end

  add_foreign_key "listening_histories", "listeners", on_delete: :cascade
  add_foreign_key "listening_histories", "musics", on_delete: :cascade
  add_foreign_key "musics", "artists", on_delete: :cascade
  add_foreign_key "subscriptions", "artists", on_delete: :cascade
  add_foreign_key "subscriptions", "listeners", on_delete: :cascade
end
