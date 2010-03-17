# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100113222038) do

  create_table "tasks", :force => true do |t|
    t.string    "body"
    t.date      "duedate"
    t.boolean   "completed"
    t.boolean   "assigned"
    t.string    "addtype", :limit => 10
    t.integer   "ordinal"
    t.integer   "user_id", :null => false
    t.datetime  "created_at"
    t.datetime  "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string    "email"
    t.string    "crypted_password"
    t.string    "password_salt"
    t.string    "persistence_token"
    t.integer   "login_count",        :default => 0, :null => false
    t.integer   "failed_login_count", :default => 0, :null => false
    t.datetime  "last_request_at"
    t.datetime  "current_login_at"
    t.datetime  "last_login_at"
    t.string    "current_login_ip"
    t.string    "last_login_ip"
    t.string    "perishable_token"
    t.boolean   "active", :default => 0
    t.string    "language", :limit => 2, :default => "en", :null => false
    t.string    "time_zone"
    t.string    "api_key", :limit => 50
    t.integer   "env_maintenance", :default => 1, :null => false
    t.integer   "env_reporting", :default => 4, :null => false
    t.integer   "env_other", :default => 1, :null => false
    t.integer   "current_list", :default => 0, :null => false
    t.datetime  "created_at"
    t.datetime  "updated_at"
  end
  
  create_table "tasklists", :force => true do |t|  
    t.integer   "user_id",  :default => 0, :null => false
    t.string    "title"
    t.integer   "security", :default => 0, :null => false  
    t.string    "key", :limit => 20
    t.datetime  "created_at"
    t.datetime  "updated_at"
  end

end
