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

ActiveRecord::Schema.define(version: 20171111141249) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "citext"
  enable_extension "pg_trgm"

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
    t.bigint "schedule_id"
    t.string "image_url"
    t.string "broadcast_url"
    t.index ["format_id"], name: "index_broadcasts_on_format_id"
    t.index ["mediathek_identification"], name: "index_broadcasts_on_mediathek_identification", unique: true
    t.index ["medium_id"], name: "index_broadcasts_on_medium_id"
    t.index ["schedule_id"], name: "index_broadcasts_on_schedule_id"
    t.index ["title"], name: "index_broadcasts_on_title", unique: true
    t.index ["topic_id"], name: "index_broadcasts_on_topic_id"
  end

  create_table "format_translations", force: :cascade do |t|
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

  create_table "impressions", id: :serial, force: :cascade do |t|
    t.integer "response"
    t.decimal "amount"
    t.integer "user_id"
    t.integer "broadcast_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "fixed"
    t.index ["broadcast_id"], name: "index_impressions_on_broadcast_id"
    t.index ["user_id", "broadcast_id"], name: "index_impressions_on_user_id_and_broadcast_id", unique: true
    t.index ["user_id"], name: "index_impressions_on_user_id"
  end

  create_table "media", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "medium_translations", force: :cascade do |t|
    t.integer "medium_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.index ["locale"], name: "index_medium_translations_on_locale"
    t.index ["medium_id"], name: "index_medium_translations_on_medium_id"
  end

  create_table "schedules", force: :cascade do |t|
    t.bigint "broadcast_id"
    t.bigint "station_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["broadcast_id", "station_id"], name: "index_schedules_on_broadcast_id_and_station_id", unique: true
    t.index ["broadcast_id"], name: "index_schedules_on_broadcast_id"
    t.index ["station_id"], name: "index_schedules_on_station_id"
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

  create_table "topic_translations", force: :cascade do |t|
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 0
    t.string "auth0_uid"
    t.boolean "has_bad_email", default: false
    t.float "latitude"
    t.float "longitude"
    t.string "country_code"
    t.string "state_code"
    t.string "postal_code"
    t.string "city"
    t.string "locale"
    t.index ["auth0_uid"], name: "index_users_on_auth0_uid", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "broadcasts", "formats"
  add_foreign_key "broadcasts", "media"
  add_foreign_key "broadcasts", "schedules"
  add_foreign_key "broadcasts", "topics"
  add_foreign_key "broadcasts", "users", column: "creator_id"
  add_foreign_key "impressions", "broadcasts"
  add_foreign_key "impressions", "users"
  add_foreign_key "stations", "media"

  create_view "statistics",  sql_definition: <<-SQL
      SELECT t.id,
      t.title,
      t.impressions,
      ((t.positives)::double precision / (NULLIF(t.impressions, 0))::double precision) AS approval,
      COALESCE(((t.total)::double precision / (NULLIF(t.positives, 0))::double precision), (0)::double precision) AS average,
      t.total,
      ((t.impressions)::numeric * a.average_amount_per_selection) AS expected_amount
     FROM (( SELECT impressions.broadcast_id AS id,
              broadcasts.title,
              count(*) AS impressions,
              COALESCE(sum(
                  CASE
                      WHEN (impressions.response = 1) THEN 1
                      ELSE 0
                  END), (0)::bigint) AS positives,
              COALESCE(sum(impressions.amount), (0)::numeric) AS total
             FROM (impressions
               JOIN broadcasts ON ((impressions.broadcast_id = broadcasts.id)))
            GROUP BY impressions.broadcast_id, broadcasts.title) t
       LEFT JOIN ( SELECT (sum(impressions.amount) / (count(*))::numeric) AS average_amount_per_selection
             FROM impressions) a ON (true));
  SQL

  create_view "statistic_broadcasts", materialized: true,  sql_definition: <<-SQL
      SELECT broadcasts.id,
      broadcasts.title,
      count(impressions.id) AS impressions,
      avg(impressions.response) AS approval,
      avg(impressions.amount) AS average,
      COALESCE(sum(impressions.amount), (0)::numeric) AS total,
      COALESCE(((count(impressions.id))::numeric * ( SELECT avg(COALESCE(impressions_1.amount, (0)::numeric)) AS avg
             FROM impressions impressions_1)), (0)::numeric) AS expected_amount
     FROM (broadcasts
       LEFT JOIN impressions ON ((impressions.broadcast_id = broadcasts.id)))
    GROUP BY broadcasts.id, broadcasts.title;
  SQL

  add_index "statistic_broadcasts", ["id"], name: "index_statistic_broadcasts_on_id", unique: true

  create_view "statistic_stations",  sql_definition: <<-SQL
      SELECT stations.id,
      stations.name,
      stations.medium_id,
      count(*) AS broadcasts_count,
      sum((t.total / (t.stations_count)::numeric)) AS total,
      sum((t.expected_amount / (t.stations_count)::numeric)) AS expected_amount
     FROM ((( SELECT statistic_broadcasts.id AS broadcast_id,
              statistic_broadcasts.total,
              statistic_broadcasts.expected_amount,
              count(*) AS stations_count
             FROM (statistic_broadcasts
               JOIN schedules schedules_1 ON ((statistic_broadcasts.id = schedules_1.broadcast_id)))
            GROUP BY statistic_broadcasts.id, statistic_broadcasts.total, statistic_broadcasts.expected_amount) t
       JOIN schedules ON ((t.broadcast_id = schedules.broadcast_id)))
       JOIN stations ON ((schedules.station_id = stations.id)))
    GROUP BY stations.id, stations.name, stations.medium_id
  UNION ALL
   SELECT stations.id,
      stations.name,
      stations.medium_id,
      0 AS broadcasts_count,
      0 AS total,
      0 AS expected_amount
     FROM (stations
       LEFT JOIN schedules ON ((stations.id = schedules.station_id)))
    WHERE (schedules.broadcast_id IS NULL);
  SQL

  create_view "statistic_media",  sql_definition: <<-SQL
      SELECT media.id,
      count(*) AS broadcasts_count,
      sum(statistic_broadcasts.total) AS total,
      sum(statistic_broadcasts.expected_amount) AS expected_amount
     FROM ((media
       JOIN broadcasts ON ((media.id = broadcasts.medium_id)))
       JOIN statistic_broadcasts ON ((broadcasts.id = statistic_broadcasts.id)))
    GROUP BY media.id
  UNION ALL
   SELECT media.id,
      0 AS broadcasts_count,
      0 AS total,
      0 AS expected_amount
     FROM (media
       LEFT JOIN broadcasts ON ((media.id = broadcasts.medium_id)))
    WHERE (broadcasts.medium_id IS NULL);
  SQL

  create_view "statistic_medium_translations",  sql_definition: <<-SQL
      SELECT medium_translations.id,
      medium_translations.medium_id,
      medium_translations.locale,
      medium_translations.created_at,
      medium_translations.updated_at,
      medium_translations.name,
      medium_translations.medium_id AS statistic_medium_id
     FROM medium_translations;
  SQL

end
