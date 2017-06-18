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

ActiveRecord::Schema.define(version: 20170616141405) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "citext"

  create_table "broadcasts", id: :serial, force: :cascade do |t|
    t.citext "title"
    t.string "description"
    t.integer "topic_id"
    t.integer "format_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "creator_id"
    t.integer "mediathek_identification"
    t.integer "medium_id"
    t.integer "station_id"
    t.index ["format_id"], name: "index_broadcasts_on_format_id"
    t.index ["mediathek_identification"], name: "index_broadcasts_on_mediathek_identification", unique: true
    t.index ["medium_id"], name: "index_broadcasts_on_medium_id"
    t.index ["station_id"], name: "index_broadcasts_on_station_id"
    t.index ["title"], name: "index_broadcasts_on_title", unique: true
    t.index ["topic_id"], name: "index_broadcasts_on_topic_id"
  end

  create_table "format_translations", id: :serial, force: :cascade do |t|
    t.integer "format_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.index ["format_id"], name: "index_format_translations_on_format_id"
    t.index ["locale"], name: "index_format_translations_on_locale"
  end

  create_table "formats", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "media", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "medium_translations", id: :serial, force: :cascade do |t|
    t.integer "medium_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.index ["locale"], name: "index_medium_translations_on_locale"
    t.index ["medium_id"], name: "index_medium_translations_on_medium_id"
  end

  create_table "selections", id: :serial, force: :cascade do |t|
    t.integer "response"
    t.decimal "amount"
    t.integer "user_id"
    t.integer "broadcast_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "fixed"
    t.index ["broadcast_id"], name: "index_selections_on_broadcast_id"
    t.index ["user_id", "broadcast_id"], name: "index_selections_on_user_id_and_broadcast_id", unique: true
    t.index ["user_id"], name: "index_selections_on_user_id"
  end

  create_table "stations", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "medium_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "broadcasts_count", default: 0
    t.index ["medium_id"], name: "index_stations_on_medium_id"
    t.index ["name"], name: "index_stations_on_name", unique: true
  end

  create_table "topic_translations", id: :serial, force: :cascade do |t|
    t.integer "topic_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.index ["locale"], name: "index_topic_translations_on_locale"
    t.index ["topic_id"], name: "index_topic_translations_on_topic_id"
  end

  create_table "topics", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "encrypted_password", default: "", null: false
    t.string "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "role", default: 0
    t.string "auth0_uid"
    t.boolean "has_bad_email", default: false
    t.float "latitude"
    t.float "longitude"
    t.index ["auth0_uid"], name: "index_users_on_auth0_uid", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "broadcasts", "formats"
  add_foreign_key "broadcasts", "media"
  add_foreign_key "broadcasts", "topics"
  add_foreign_key "broadcasts", "users", column: "creator_id"
  add_foreign_key "selections", "broadcasts"
  add_foreign_key "selections", "users"
  add_foreign_key "stations", "media"

  create_view "statistics",  sql_definition: <<-SQL
      SELECT t.id,
      t.title,
      t.votes,
      ((t.positives)::double precision / (NULLIF(t.votes, 0))::double precision) AS approval,
      COALESCE(((t.total)::double precision / (NULLIF(t.positives, 0))::double precision), (0)::double precision) AS average,
      t.total
     FROM ( SELECT selections.broadcast_id AS id,
              broadcasts.title,
              count(*) AS votes,
              COALESCE(sum(
                  CASE
                      WHEN (selections.response = 1) THEN 1
                      ELSE 0
                  END), (0)::bigint) AS positives,
              COALESCE(sum(selections.amount), (0)::numeric) AS total
             FROM (selections
               JOIN broadcasts ON ((selections.broadcast_id = broadcasts.id)))
            GROUP BY selections.broadcast_id, broadcasts.title) t;
  SQL

end
