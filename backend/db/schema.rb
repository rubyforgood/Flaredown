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

ActiveRecord::Schema.define(version: 20160129064538) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_trgm"

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
    t.boolean  "global",     default: true
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "profiles", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "country_id"
    t.date     "birth_date"
    t.string   "sex_id"
    t.string   "onboarding_step_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

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
    t.boolean  "global",     default: true
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "trackings", force: :cascade do |t|
    t.integer "user_id"
    t.integer "trackable_id"
    t.string  "trackable_type"
    t.date    "start_at"
    t.date    "end_at"
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
    t.boolean  "global",     default: true
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "user_conditions", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "condition_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "user_conditions", ["condition_id"], name: "index_user_conditions_on_condition_id", using: :btree
  add_index "user_conditions", ["user_id"], name: "index_user_conditions_on_user_id", using: :btree

  create_table "user_symptoms", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "symptom_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "user_symptoms", ["symptom_id"], name: "index_user_symptoms_on_symptom_id", using: :btree
  add_index "user_symptoms", ["user_id"], name: "index_user_symptoms_on_user_id", using: :btree

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

  add_foreign_key "profiles", "users"
  add_foreign_key "trackings", "users"
  add_foreign_key "user_conditions", "conditions"
  add_foreign_key "user_conditions", "users"
  add_foreign_key "user_symptoms", "symptoms"
  add_foreign_key "user_symptoms", "users"
  add_foreign_key "user_treatments", "treatments"
  add_foreign_key "user_treatments", "users"
end
