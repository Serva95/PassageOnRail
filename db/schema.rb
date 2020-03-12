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

ActiveRecord::Schema.define(version: 2020_03_12_093819) do

  create_table "chats", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "driver_id"
    t.integer "hitch_hiker_id"
    t.index ["driver_id"], name: "index_chats_on_driver_id"
    t.index ["hitch_hiker_id"], name: "index_chats_on_hitch_hiker_id"
  end

  create_table "drivers", force: :cascade do |t|
    t.float "rating_medio"
    t.boolean "deleted"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "email"
  end

  create_table "hitch_hikers", force: :cascade do |t|
    t.float "rating_medio"
    t.boolean "deleted"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "email"
  end

  create_table "messagges", force: :cascade do |t|
    t.datetime "data_ora"
    t.text "testo"
    t.string "mittente"
    t.string "destinatario"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "chat_id"
    t.index ["chat_id"], name: "index_messagges_on_chat_id"
  end

  create_table "multi_trip_associations", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "single_trip_id"
    t.integer "multi_trip_id"
    t.index ["multi_trip_id"], name: "index_multi_trip_associations_on_multi_trip_id"
    t.index ["single_trip_id"], name: "index_multi_trip_associations_on_single_trip_id"
  end

  create_table "multi_trips", force: :cascade do |t|
    t.datetime "data_ora_partenza"
    t.string "citta_partenza"
    t.datetime "data_ora_arrivo"
    t.string "citta_arrivo"
    t.integer "costo_totale"
    t.float "comfort_medio"
    t.integer "numero_cambi"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "passenger_associations", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "hitch_hiker_id"
    t.integer "single_trip_id"
    t.index ["hitch_hiker_id"], name: "index_passenger_associations_on_hitch_hiker_id"
    t.index ["single_trip_id"], name: "index_passenger_associations_on_single_trip_id"
  end

  create_table "ratings", force: :cascade do |t|
    t.datetime "data"
    t.integer "rating"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "driver_id"
    t.integer "hitch_hiker_id"
    t.index ["driver_id"], name: "index_ratings_on_driver_id"
    t.index ["hitch_hiker_id"], name: "index_ratings_on_hitch_hiker_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.datetime "data"
    t.integer "rating"
    t.text "commento"
    t.boolean "deleted"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "driver_id"
    t.integer "hitch_hiker_id"
    t.index ["driver_id"], name: "index_reviews_on_driver_id"
    t.index ["hitch_hiker_id"], name: "index_reviews_on_hitch_hiker_id"
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
  end

  create_table "single_trips", force: :cascade do |t|
    t.integer "n_passeggeri"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "route_id"
    t.index ["route_id"], name: "index_single_trips_on_route_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "username"
    t.string "password"
    t.string "nome"
    t.string "cognome"
    t.date "data_di_nascita"
    t.string "cellulare"
    t.text "indirizzo"
    t.string "url_foto"
    t.boolean "deleted"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
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
    t.index ["driver_id"], name: "index_vehicles_on_driver_id"
  end

  add_foreign_key "chats", "drivers"
  add_foreign_key "chats", "hitch_hikers"
  add_foreign_key "messagges", "chats"
  add_foreign_key "multi_trip_associations", "multi_trips"
  add_foreign_key "multi_trip_associations", "single_trips"
  add_foreign_key "passenger_associations", "hitch_hikers"
  add_foreign_key "passenger_associations", "single_trips"
  add_foreign_key "ratings", "drivers"
  add_foreign_key "ratings", "hitch_hikers"
  add_foreign_key "reviews", "drivers"
  add_foreign_key "reviews", "hitch_hikers"
  add_foreign_key "routes", "drivers"
  add_foreign_key "routes", "vehicles"
  add_foreign_key "single_trips", "routes"
  add_foreign_key "vehicles", "drivers"
end
