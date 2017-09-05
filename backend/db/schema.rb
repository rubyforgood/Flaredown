# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20170822122800) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_trgm"
  enable_extension "hstore"

  create_table "condition_translations", force: :cascade do |t|
    t.integer  "condition_id", null: false
    t.string   "locale",       null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "name"
  end

  add_index "condition_translations", ["condition_id"], name: "index_condition_translations_on_condition_id", using: :btree
  add_index "condition_translations", ["locale"], name: "index_condition_translations_on_locale", using: :btree

  create_table "conditions", force: :cascade do |t|
    t.boolean  "global",                 default: true
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "trackable_usages_count", default: 0
  end

  create_table "crono_jobs", force: :cascade do |t|
    t.string   "job_id",            null: false
    t.text     "log"
    t.datetime "last_performed_at"
    t.boolean  "healthy"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "crono_jobs", ["job_id"], name: "index_crono_jobs_on_job_id", unique: true, using: :btree

  create_table "food_translations", force: :cascade do |t|
    t.integer  "food_id",    null: false
    t.string   "locale",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "long_desc",  null: false
    t.string   "shrt_desc"
    t.string   "comname"
    t.string   "sciname"
  end

  add_index "food_translations", ["food_id"], name: "index_food_translations_on_food_id", using: :btree
  add_index "food_translations", ["locale"], name: "index_food_translations_on_locale", using: :btree

  create_table "foods", force: :cascade do |t|
    t.string   "ndb_no"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.boolean  "global",                 default: true
    t.integer  "trackable_usages_count", default: 0
  end

  add_index "foods", ["ndb_no"], name: "index_foods_on_ndb_no", using: :btree

  create_table "positions", force: :cascade do |t|
    t.string  "postal_code",                            null: false
    t.string  "location_name",                          null: false
    t.decimal "latitude",      precision: 10, scale: 7
    t.decimal "longitude",     precision: 10, scale: 7
  end

  create_table "profiles", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "country_id"
    t.date     "birth_date"
    t.string   "sex_id"
    t.string   "onboarding_step_id"
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.string   "ethnicity_ids_string"
    t.string   "day_habit_id"
    t.string   "education_level_id"
    t.integer  "day_walking_hours"
    t.hstore   "most_recent_doses"
    t.string   "screen_name"
    t.hstore   "most_recent_conditions_positions"
    t.hstore   "most_recent_symptoms_positions"
    t.hstore   "most_recent_treatments_positions"
    t.integer  "pressure_units",                   default: 0
    t.integer  "temperature_units",                default: 0
    t.boolean  "beta_tester",                      default: false
    t.boolean  "notify",                           default: true
    t.string   "notify_token"
    t.string   "slug_name"
    t.boolean  "checkin_reminder",                 default: false
    t.datetime "checkin_reminder_at"
    t.string   "time_zone_name"
    t.string   "reminder_job_id"
  end

  add_index "profiles", ["slug_name"], name: "index_profiles_on_slug_name", using: :btree
  add_index "profiles", ["user_id"], name: "index_profiles_on_user_id", using: :btree

  create_table "symptom_translations", force: :cascade do |t|
    t.integer  "symptom_id", null: false
    t.string   "locale",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name"
  end

  add_index "symptom_translations", ["locale"], name: "index_symptom_translations_on_locale", using: :btree
  add_index "symptom_translations", ["symptom_id"], name: "index_symptom_translations_on_symptom_id", using: :btree

  create_table "symptoms", force: :cascade do |t|
    t.boolean  "global",                 default: true
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "trackable_usages_count", default: 0
  end

  create_table "tag_translations", force: :cascade do |t|
    t.integer  "tag_id",     null: false
    t.string   "locale",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name"
  end

  add_index "tag_translations", ["locale"], name: "index_tag_translations_on_locale", using: :btree
  add_index "tag_translations", ["tag_id"], name: "index_tag_translations_on_tag_id", using: :btree

  create_table "tags", force: :cascade do |t|
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.boolean  "global",                 default: true
    t.integer  "trackable_usages_count", default: 0
  end

  create_table "trackable_usages", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.integer  "count",          default: 1
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "trackable_usages", ["trackable_type", "trackable_id"], name: "index_trackable_usages_on_trackable_type_and_trackable_id", using: :btree
  add_index "trackable_usages", ["user_id", "trackable_type", "trackable_id"], name: "index_trackable_usages_on_unique_columns", unique: true, using: :btree
  add_index "trackable_usages", ["user_id"], name: "index_trackable_usages_on_user_id", using: :btree

  create_table "trackings", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.date     "start_at"
    t.date     "end_at"
    t.integer  "color_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "trackings", ["trackable_type", "trackable_id"], name: "index_trackings_on_trackable_type_and_trackable_id", using: :btree
  add_index "trackings", ["trackable_type"], name: "index_trackings_on_trackable_type", using: :btree
  add_index "trackings", ["user_id", "trackable_id", "trackable_type", "start_at"], name: "index_trackings_unique_trackable", unique: true, using: :btree
  add_index "trackings", ["user_id"], name: "index_trackings_on_user_id", using: :btree

  create_table "treatment_translations", force: :cascade do |t|
    t.integer  "treatment_id", null: false
    t.string   "locale",       null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "name"
  end

  add_index "treatment_translations", ["locale"], name: "index_treatment_translations_on_locale", using: :btree
  add_index "treatment_translations", ["treatment_id"], name: "index_treatment_translations_on_treatment_id", using: :btree

  create_table "treatments", force: :cascade do |t|
    t.boolean  "global",                 default: true
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "trackable_usages_count", default: 0
  end

  create_table "user_conditions", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "condition_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "user_conditions", ["condition_id"], name: "index_user_conditions_on_condition_id", using: :btree
  add_index "user_conditions", ["user_id"], name: "index_user_conditions_on_user_id", using: :btree

  create_table "user_foods", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "food_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "user_foods", ["food_id"], name: "index_user_foods_on_food_id", using: :btree
  add_index "user_foods", ["user_id"], name: "index_user_foods_on_user_id", using: :btree

  create_table "user_symptoms", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "symptom_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "user_symptoms", ["symptom_id"], name: "index_user_symptoms_on_symptom_id", using: :btree
  add_index "user_symptoms", ["user_id"], name: "index_user_symptoms_on_user_id", using: :btree

  create_table "user_tags", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "user_tags", ["tag_id"], name: "index_user_tags_on_tag_id", using: :btree
  add_index "user_tags", ["user_id"], name: "index_user_tags_on_user_id", using: :btree

  create_table "user_treatments", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "treatment_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "user_treatments", ["treatment_id"], name: "index_user_treatments_on_treatment_id", using: :btree
  add_index "user_treatments", ["user_id"], name: "index_user_treatments_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "authentication_token",                null: false
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", using: :btree

  create_table "weathers", force: :cascade do |t|
    t.date     "date"
    t.string   "postal_code"
    t.string   "icon"
    t.string   "summary"
    t.float    "temperature_min"
    t.float    "temperature_max"
    t.float    "precip_intensity"
    t.float    "pressure"
    t.float    "humidity"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "position_id"
  end

  add_index "weathers", ["date", "postal_code"], name: "index_weathers_on_date_and_postal_code", unique: true, using: :btree

  add_foreign_key "profiles", "users"
  add_foreign_key "trackable_usages", "users"
  add_foreign_key "trackings", "users"
  add_foreign_key "user_conditions", "conditions"
  add_foreign_key "user_conditions", "users"
  add_foreign_key "user_foods", "foods"
  add_foreign_key "user_foods", "users"
  add_foreign_key "user_symptoms", "symptoms"
  add_foreign_key "user_symptoms", "users"
  add_foreign_key "user_tags", "tags"
  add_foreign_key "user_tags", "users"
  add_foreign_key "user_treatments", "treatments"
  add_foreign_key "user_treatments", "users"
  add_foreign_key "weathers", "positions"
end
