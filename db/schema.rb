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

ActiveRecord::Schema[8.0].define(version: 2025_07_30_143307) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pgcrypto"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "appetite", ["actively_looking", "interested", "not_open"]
  create_enum "phase", ["primary", "secondary"]

  create_table "academic_years", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.date "starts_on", null: false
    t.date "ends_on", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_academic_years_on_name", unique: true
  end

  create_table "organisation_addresses", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "organisation_id", null: false
    t.string "address_1"
    t.string "address_2"
    t.string "address_3"
    t.string "town"
    t.string "city"
    t.string "county"
    t.string "postcode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organisation_id"], name: "index_organisation_addresses_on_organisation_id", unique: true
  end

  create_table "organisation_contacts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "organisation_id", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "email_address", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_organisation_contacts_on_email_address"
    t.index ["organisation_id"], name: "index_organisation_contacts_on_organisation_id"
  end

  create_table "organisations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "urn"
    t.string "ukprn"
    t.string "code"
    t.float "longitude"
    t.float "latitude"
    t.string "email_address"
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "admissions_policy"
    t.string "district_admin_code"
    t.string "district_admin_name"
    t.string "gender"
    t.string "group"
    t.date "last_inspection_date"
    t.string "local_authority_code"
    t.string "local_authority_name"
    t.integer "maximum_age"
    t.integer "minimum_age"
    t.integer "percentage_free_school_meals"
    t.string "phase"
    t.string "rating"
    t.string "religious_character"
    t.integer "school_capacity"
    t.string "send_provision"
    t.string "special_classes"
    t.string "telephone"
    t.integer "total_boys"
    t.integer "total_girls"
    t.integer "total_pupils"
    t.string "type_of_establishment"
    t.string "urban_or_rural"
    t.string "website"
    t.index ["code"], name: "index_organisations_on_code"
    t.index ["ukprn"], name: "index_organisations_on_ukprn"
    t.index ["urn"], name: "index_organisations_on_urn", unique: true, where: "((type)::text = 'School'::text)"
  end

  create_table "placement_preferences", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "academic_year_id", null: false
    t.uuid "organisation_id", null: false
    t.uuid "created_by_id", null: false
    t.enum "appetite", enum_type: "appetite"
    t.jsonb "placement_details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["academic_year_id"], name: "index_placement_preferences_on_academic_year_id"
    t.index ["created_by_id"], name: "index_placement_preferences_on_created_by_id"
    t.index ["organisation_id"], name: "index_placement_preferences_on_organisation_id"
  end

  create_table "placement_subjects", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "code"
    t.enum "phase", enum_type: "phase"
    t.uuid "parent_subject_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_placement_subjects_on_code", unique: true
    t.index ["parent_subject_id"], name: "index_placement_subjects_on_parent_subject_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "user_memberships", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "organisation_id", null: false
    t.uuid "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organisation_id"], name: "index_user_memberships_on_organisation_id"
    t.index ["user_id"], name: "index_user_memberships_on_user_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "email_address", null: false
    t.boolean "admin", default: false
    t.uuid "dfe_sign_in_uid"
    t.datetime "last_signed_in_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "organisation_addresses", "organisations"
  add_foreign_key "organisation_contacts", "organisations"
  add_foreign_key "placement_preferences", "academic_years"
  add_foreign_key "placement_preferences", "organisations"
  add_foreign_key "user_memberships", "organisations"
  add_foreign_key "user_memberships", "users"
end
