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

ActiveRecord::Schema.define(version: 2020_09_28_080356) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "chats", force: :cascade do |t|
    t.integer "user_1_id"
    t.integer "user_2_id"
    t.datetime "open_time_user_1", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "open_time_user_2", precision: 6, null: false
    t.boolean "deleted_user_1", default: false, null: false
    t.boolean "deleted_user_2", default: false, null: false
    t.index ["user_1_id"], name: "index_chats_on_user_1_id"
    t.index ["user_2_id"], name: "index_chats_on_user_2_id"
  end

  create_table "drivers", force: :cascade do |t|
    t.float "rating_medio"
    t.boolean "deleted"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "journeys", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "n_prenotati"
    t.bigint "user_id"
    t.bigint "pay_method_id"
    t.index ["pay_method_id"], name: "index_journeys_on_pay_method_id"
    t.index ["user_id"], name: "index_journeys_on_user_id"
  end

  create_table "messagges", force: :cascade do |t|
    t.datetime "data_ora", precision: 6, null: false
    t.text "testo", null: false
    t.bigint "chat_id"
    t.bigint "user_id"
    t.index ["chat_id"], name: "index_messagges_on_chat_id"
    t.index ["user_id"], name: "index_messagges_on_user_id"
  end

  create_table "notifications", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "actor_id"
    t.string "notify_type", null: false
    t.string "target_type"
    t.integer "target_id"
    t.string "second_target_type"
    t.integer "second_target_id"
    t.string "third_target_type"
    t.integer "third_target_id"
    t.datetime "read_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "notify_type"], name: "index_notifications_on_user_id_and_notify_type"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "pay_methods", force: :cascade do |t|
    t.string "intestatario", null: false
    t.string "numero", null: false
    t.integer "mese_scadenza", null: false
    t.integer "anno_scadenza", null: false
    t.string "cvv", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_pay_methods_on_user_id"
  end

  create_table "ratings", force: :cascade do |t|
    t.datetime "data", precision: 6, null: false
    t.integer "vote", null: false
    t.bigint "driver_id"
    t.bigint "user_id"
    t.index ["driver_id"], name: "index_ratings_on_driver_id"
    t.index ["user_id"], name: "index_ratings_on_user_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.datetime "data", precision: 6, null: false
    t.integer "vote", null: false
    t.text "commento", null: false
    t.boolean "deleted", default: false, null: false
    t.bigint "driver_id"
    t.bigint "user_id"
    t.index ["driver_id"], name: "index_reviews_on_driver_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "routes", force: :cascade do |t|
    t.string "citta_partenza"
    t.string "luogo_ritrovo"
    t.datetime "data_ora_partenza"
    t.string "citta_arrivo"
    t.datetime "data_ora_arrivo"
    t.float "costo"
    t.boolean "deleted"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "driver_id"
    t.bigint "vehicle_id"
    t.integer "n_passeggeri", default: 0
    t.integer "tempo_percorrenza"
    t.boolean "contanti", default: false, null: false
    t.index ["driver_id"], name: "index_routes_on_driver_id"
    t.index ["vehicle_id"], name: "index_routes_on_vehicle_id"
  end

  create_table "searches", force: :cascade do |t|
    t.string "c_partenza"
    t.string "c_arrivo"
    t.datetime "data_ora"
    t.float "rating"
    t.float "costo"
    t.string "tipo_mezzo"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "comfort"
    t.string "sort_attribute"
    t.string "sort_order"
    t.boolean "multitrip"
  end

  create_table "stages", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "route_id"
    t.bigint "journey_id"
    t.boolean "accepted"
    t.index ["journey_id"], name: "index_stages_on_journey_id"
    t.index ["route_id"], name: "index_stages_on_route_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "nome"
    t.string "cognome"
    t.date "data_di_nascita"
    t.string "cellulare"
    t.text "indirizzo"
    t.boolean "deleted"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "driver_id"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "avatar"
    t.float "hitch_hiker_rating"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["driver_id"], name: "index_users_on_driver_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "vehicles", force: :cascade do |t|
    t.string "targa"
    t.string "marca"
    t.string "modello"
    t.date "immatricolazione"
    t.integer "comfort"
    t.integer "posti"
    t.boolean "deleted"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "driver_id"
    t.string "tipo_mezzo"
    t.index ["driver_id"], name: "index_vehicles_on_driver_id"
  end

  add_foreign_key "chats", "users", column: "user_1_id"
  add_foreign_key "chats", "users", column: "user_2_id"
  add_foreign_key "journeys", "pay_methods"
  add_foreign_key "journeys", "users"
  add_foreign_key "messagges", "chats"
  add_foreign_key "messagges", "users"
  add_foreign_key "pay_methods", "users"
  add_foreign_key "ratings", "drivers"
  add_foreign_key "ratings", "users"
  add_foreign_key "reviews", "drivers"
  add_foreign_key "reviews", "users"
  add_foreign_key "routes", "drivers"
  add_foreign_key "routes", "vehicles"
  add_foreign_key "stages", "journeys"
  add_foreign_key "stages", "routes"
  add_foreign_key "users", "drivers"
  add_foreign_key "vehicles", "drivers"

  create_view "multitrip_search_results", sql_definition: <<-SQL
      SELECT routes.id,
      routes.citta_partenza,
      routes.luogo_ritrovo,
      routes.data_ora_partenza,
      routes.citta_arrivo,
      routes.data_ora_arrivo,
      routes.costo,
      routes.deleted,
      routes.created_at,
      routes.updated_at,
      routes.driver_id,
      routes.vehicle_id,
      routes.n_passeggeri,
      routes.tempo_percorrenza,
      vehicles.comfort,
      vehicles.tipo_mezzo,
      drivers.rating_medio,
      vehicles.posti
     FROM ((routes
       JOIN vehicles ON ((routes.vehicle_id = vehicles.id)))
       JOIN drivers ON ((routes.driver_id = drivers.id)));
  SQL
end
