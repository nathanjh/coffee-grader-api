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

ActiveRecord::Schema.define(version: 20170323194618) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "coffees", force: :cascade do |t|
    t.string   "name"
    t.string   "origin"
    t.string   "producer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "variety"
  end

  create_table "cupped_coffees", force: :cascade do |t|
    t.datetime "roast_date"
    t.string   "coffee_alias"
    t.integer  "coffee_id"
    t.integer  "roaster_id"
    t.integer  "cupping_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["coffee_id"], name: "index_cupped_coffees_on_coffee_id", using: :btree
    t.index ["cupping_id"], name: "index_cupped_coffees_on_cupping_id", using: :btree
    t.index ["roaster_id"], name: "index_cupped_coffees_on_roaster_id", using: :btree
  end

  create_table "cuppings", force: :cascade do |t|
    t.string   "location"
    t.datetime "cup_date"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "host_id"
    t.integer  "cups_per_sample"
    t.index ["host_id"], name: "index_cuppings_on_host_id", using: :btree
  end

  create_table "invites", force: :cascade do |t|
    t.integer  "cupping_id"
    t.integer  "grader_id"
    t.integer  "status",     default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["cupping_id"], name: "index_invites_on_cupping_id", using: :btree
    t.index ["grader_id"], name: "index_invites_on_grader_id", using: :btree
  end

  create_table "roasters", force: :cascade do |t|
    t.string   "name"
    t.string   "location"
    t.string   "website"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "scores", force: :cascade do |t|
    t.integer  "cupped_coffee_id"
    t.integer  "cupping_id"
    t.integer  "roast_level"
    t.decimal  "aroma",            precision: 4, scale: 2
    t.decimal  "aftertaste",       precision: 4, scale: 2
    t.decimal  "acidity",          precision: 4, scale: 2
    t.decimal  "body",             precision: 4, scale: 2
    t.decimal  "uniformity"
    t.decimal  "balance",          precision: 4, scale: 2
    t.decimal  "clean_cup"
    t.decimal  "sweetness"
    t.decimal  "overall",          precision: 4, scale: 2
    t.integer  "defects"
    t.decimal  "total_score"
    t.text     "notes"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.integer  "grader_id"
    t.index ["cupped_coffee_id"], name: "index_scores_on_cupped_coffee_id", using: :btree
    t.index ["cupping_id"], name: "index_scores_on_cupping_id", using: :btree
    t.index ["grader_id"], name: "index_scores_on_grader_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "provider",               default: "email", null: false
    t.string   "uid",                    default: "",      null: false
    t.string   "encrypted_password",     default: "",      null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "name"
    t.string   "username"
    t.string   "image"
    t.string   "email"
    t.json     "tokens"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true, using: :btree
  end

  add_foreign_key "cupped_coffees", "coffees"
  add_foreign_key "cupped_coffees", "cuppings"
  add_foreign_key "cupped_coffees", "roasters"
  add_foreign_key "cuppings", "users", column: "host_id"
  add_foreign_key "invites", "cuppings"
  add_foreign_key "invites", "users", column: "grader_id"
  add_foreign_key "scores", "cupped_coffees"
  add_foreign_key "scores", "cuppings"
  add_foreign_key "scores", "users", column: "grader_id"
end
