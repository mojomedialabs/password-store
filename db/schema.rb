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

ActiveRecord::Schema.define(:version => 20120120185412) do

  create_table "passwords", :force => true do |t|
    t.integer  "user_id",     :null => false
    t.text     "name",        :null => false
    t.text     "login_name"
    t.text     "url"
    t.text     "description"
    t.text     "iv",          :null => false
    t.text     "cipher_text", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.text     "email_address",                         :null => false
    t.text     "password_hash",                         :null => false
    t.text     "password_salt",                         :null => false
    t.text     "remember_me_token"
    t.text     "password_reset_token"
    t.text     "first_name"
    t.text     "last_name"
    t.text     "phone_number"
    t.text     "ip_addresses"
    t.integer  "privilege_level",        :default => 1, :null => false
    t.integer  "login_count",            :default => 0, :null => false
    t.datetime "password_reset_sent_at"
    t.datetime "last_login"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "versions", :force => true do |t|
    t.string   "item_type",  :null => false
    t.integer  "item_id",    :null => false
    t.string   "event",      :null => false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], :name => "index_versions_on_item_type_and_item_id"

end
