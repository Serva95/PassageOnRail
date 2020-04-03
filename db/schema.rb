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

ActiveRecord::Schema.define(version: 2020_04_02_133114) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "chats", force: :cascade do |t|
    t.integer "user_1_id"
    t.integer "user_2_id"
    t.datetime "opened_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_1_id"], name: "index_chats_on_user_1_id"
    t.index ["user_2_id"], name: "index_chats_on_user_2_id"
  end

  create_table "drivers", force: :cascade do |t|
    t.float "rating_medio"
    t.boolean "deleted"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "messagges", force: :cascade do |t|
    t.datetime "data_ora", null: false
    t.text "testo", null: false
    t.integer "chat_id"
    t.integer "user_id"
    t.index ["chat_id"], name: "index_messagges_on_chat_id"
    t.index ["user_id"], name: "index_messagges_on_user_id"
  end

  create_table "multi_trip_associations", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "route_id1"
    t.integer "route_id2"
    t.bigint "user_id"
    t.integer "posti_prenotati"
    t.float "prezzo_t"
    t.datetime "tempo_t"
    t.index ["route_id1"], name: "index_multi_trip_associations_on_route_id1"
    t.index ["user_id"], name: "index_multi_trip_associations_on_user_id"
  end

  create_table "passenger_associations", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "route_id"
    t.integer "n_prenotati"
    t.bigint "user_id"
    t.index ["route_id", "user_id"], name: "index_passenger_associations_on_route_id_and_user_id", unique: true
    t.index ["route_id"], name: "index_passenger_associations_on_route_id"
    t.index ["user_id"], name: "index_passenger_associations_on_user_id"
  end

  create_table "ratings", force: :cascade do |t|
    t.datetime "data", null: false
    t.integer "vote", null: false
    t.integer "driver_id"
    t.bigint "user_id"
    t.index ["driver_id"], name: "index_ratings_on_driver_id"
    t.index ["user_id"], name: "index_ratings_on_user_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.datetime "data", null: false
    t.integer "vote", null: false
    t.text "commento"
    t.boolean "deleted"
    t.integer "driver_id"
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
    t.integer "driver_id"
    t.integer "vehicle_id"
    t.integer "tempo_percorrenza"
    t.integer "n_passeggeri", default: 0
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
    t.integer "driver_id"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "avatar"
    t.float "hitch_hiker_rating"
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
    t.integer "driver_id"
    t.string "tipo_mezzo"
    t.index ["driver_id"], name: "index_vehicles_on_driver_id"
  end

  add_foreign_key "chats", "users", column: "user_1_id"
  add_foreign_key "chats", "users", column: "user_2_id"
  add_foreign_key "messagges", "chats"
  add_foreign_key "messagges", "users"
  add_foreign_key "multi_trip_associations", "routes", column: "route_id1"
  add_foreign_key "multi_trip_associations", "routes", column: "route_id2"
  add_foreign_key "multi_trip_associations", "users"
  add_foreign_key "passenger_associations", "routes"
  add_foreign_key "passenger_associations", "users"
  add_foreign_key "ratings", "drivers"
  add_foreign_key "ratings", "users"
  add_foreign_key "reviews", "drivers"
  add_foreign_key "reviews", "users"
  add_foreign_key "routes", "drivers"
  add_foreign_key "routes", "vehicles"
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
      routes.tempo_percorrenza,
      routes.n_passeggeri,
      vehicles.comfort,
      vehicles.tipo_mezzo,
      drivers.rating_medio,
      vehicles.posti
     FROM ((routes
       JOIN vehicles ON ((routes.vehicle_id = vehicles.id)))
       JOIN drivers ON ((routes.driver_id = drivers.id)));
  SQL
end
