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

ActiveRecord::Schema[7.2].define(version: 2024_11_10_060745) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "clients", force: :cascade do |t|
    t.string "dni"
    t.string "name"
    t.string "last_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "invoices", force: :cascade do |t|
    t.bigint "reservation_id", null: false
    t.bigint "payment_type_id", null: false
    t.decimal "tax"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["payment_type_id"], name: "index_invoices_on_payment_type_id"
    t.index ["reservation_id"], name: "index_invoices_on_reservation_id"
  end

  create_table "payment_types", force: :cascade do |t|
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rates", force: :cascade do |t|
    t.string "car_type"
    t.decimal "value_per_day"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reparations", force: :cascade do |t|
    t.bigint "vehicle_id", null: false
    t.date "entry_day"
    t.date "exit_day"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["vehicle_id"], name: "index_reparations_on_vehicle_id"
  end

  create_table "reservations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "client_id", null: false
    t.bigint "vehicle_id", null: false
    t.date "reservation_date"
    t.date "refund_date"
    t.string "car_status"
    t.bigint "rate_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status_reservation", default: "in_reserved"
    t.index ["client_id"], name: "index_reservations_on_client_id"
    t.index ["rate_id"], name: "index_reservations_on_rate_id"
    t.index ["user_id"], name: "index_reservations_on_user_id"
    t.index ["vehicle_id"], name: "index_reservations_on_vehicle_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "jti", null: false
    t.string "name"
    t.string "lastname"
    t.string "address"
    t.string "phone"
    t.date "birthdate"
    t.string "username"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "vehicles", force: :cascade do |t|
    t.string "brand"
    t.string "model"
    t.string "license_plate"
    t.integer "year"
    t.string "type"
    t.string "status"
    t.decimal "daily_rate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "invoices", "payment_types"
  add_foreign_key "invoices", "reservations"
  add_foreign_key "reparations", "vehicles"
  add_foreign_key "reservations", "clients"
  add_foreign_key "reservations", "rates"
  add_foreign_key "reservations", "users"
  add_foreign_key "reservations", "vehicles"
end
