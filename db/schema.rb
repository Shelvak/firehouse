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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130912182945) do

  create_table "buildings", :force => true do |t|
    t.string   "address"
    t.text     "description"
    t.string   "floor"
    t.string   "roof"
    t.string   "window"
    t.string   "electrics"
    t.text     "damage"
    t.integer  "mobile_intervention_id"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  create_table "endowment_line_firefighter_relations", :force => true do |t|
    t.integer  "endowment_line_id", :null => false
    t.integer  "firefighter_id",    :null => false
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "endowment_line_firefighter_relations", ["endowment_line_id", "firefighter_id"], :name => "endowment_line_id_firefighter_id_relation_index", :unique => true

  create_table "endowment_lines", :force => true do |t|
    t.integer  "charge",       :null => false
    t.integer  "endowment_id", :null => false
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "endowment_lines", ["endowment_id"], :name => "index_endowment_lines_on_endowment_id"

  create_table "endowments", :force => true do |t|
    t.integer  "number",                       :null => false
    t.integer  "intervention_id",              :null => false
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.integer  "truck_id"
    t.string   "out_at",          :limit => 5
    t.string   "arrive_at",       :limit => 5
    t.string   "back_at",         :limit => 5
    t.string   "in_at",           :limit => 5
    t.integer  "out_mileage"
    t.integer  "arrive_mileage"
    t.integer  "back_mileage"
    t.integer  "in_mileage"
  end

  add_index "endowments", ["intervention_id"], :name => "index_endowments_on_intervention_id"
  add_index "endowments", ["number"], :name => "index_endowments_on_number"
  add_index "endowments", ["truck_id"], :name => "index_endowments_on_truck_id"

  create_table "firefighters", :force => true do |t|
    t.string   "firstname",      :null => false
    t.string   "lastname",       :null => false
    t.string   "identification", :null => false
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "firefighters", ["firstname"], :name => "index_firefighters_on_firstname"
  add_index "firefighters", ["identification"], :name => "index_firefighters_on_identification", :unique => true
  add_index "firefighters", ["lastname"], :name => "index_firefighters_on_lastname"

  create_table "hierarchies", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "hierarchies", ["name"], :name => "index_hierarchies_on_name"

  create_table "informers", :force => true do |t|
    t.string   "full_name",       :null => false
    t.integer  "nid"
    t.string   "phone"
    t.string   "address"
    t.integer  "intervention_id", :null => false
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "informers", ["intervention_id"], :name => "index_informers_on_intervention_id"

  create_table "intervention_types", :force => true do |t|
    t.string   "name"
    t.integer  "priority"
    t.integer  "intervention_type_id"
    t.string   "image"
    t.string   "color"
    t.string   "target"
    t.string   "callback"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  create_table "interventions", :force => true do |t|
    t.integer  "number",               :null => false
    t.string   "address",              :null => false
    t.string   "near_corner"
    t.string   "kind_notes"
    t.integer  "receptor_id",          :null => false
    t.text     "observations"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.integer  "sco_id"
    t.integer  "intervention_type_id"
    t.string   "latitude"
    t.string   "longitude"
  end

  add_index "interventions", ["number"], :name => "index_interventions_on_number", :unique => true
  add_index "interventions", ["receptor_id"], :name => "index_interventions_on_receptor_id"

  create_table "mobile_interventions", :force => true do |t|
    t.datetime "date"
    t.string   "emergency"
    t.text     "observations"
    t.integer  "endowment_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "people", :force => true do |t|
    t.string   "name"
    t.string   "last_name"
    t.string   "address"
    t.string   "dni_type"
    t.string   "dni_number"
    t.integer  "age"
    t.string   "phone_number"
    t.string   "relation"
    t.string   "moved_to"
    t.text     "injuries"
    t.integer  "building_id"
    t.integer  "vehicle_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "scos", :force => true do |t|
    t.string   "full_name",                     :null => false
    t.boolean  "current",    :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "statuses", :force => true do |t|
    t.string   "name",            :default => "open"
    t.integer  "trackeable_id"
    t.string   "trackeable_type"
    t.integer  "user_id"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  add_index "statuses", ["trackeable_id"], :name => "index_statuses_on_trackeable_id"
  add_index "statuses", ["user_id"], :name => "index_statuses_on_user_id"

  create_table "supports", :force => true do |t|
    t.string   "support_type"
    t.string   "number"
    t.string   "responsible"
    t.string   "driver"
    t.string   "owner"
    t.integer  "mobile_intervention_id"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  create_table "trucks", :force => true do |t|
    t.integer  "number"
    t.integer  "mileage"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "trucks", ["number"], :name => "index_trucks_on_number", :unique => true

  create_table "users", :force => true do |t|
    t.string   "name",                                   :null => false
    t.string   "lastname"
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "roles_mask",             :default => 0,  :null => false
    t.integer  "lock_version",           :default => 0,  :null => false
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.integer  "hierarchy_id"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["lastname"], :name => "index_users_on_lastname"
  add_index "users", ["name"], :name => "index_users_on_name"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "vehicles", :force => true do |t|
    t.string   "mark"
    t.string   "model"
    t.string   "year"
    t.string   "domain"
    t.text     "damage"
    t.integer  "mobile_intervention_id"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  create_table "versions", :force => true do |t|
    t.string   "item_type",  :null => false
    t.integer  "item_id",    :null => false
    t.string   "event",      :null => false
    t.integer  "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], :name => "index_versions_on_item_type_and_item_id"
  add_index "versions", ["whodunnit"], :name => "index_versions_on_whodunnit"

end
