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

ActiveRecord::Schema.define(:version => 20130512073206) do

  create_table "browser_versions", :force => true do |t|
    t.integer  "browser_id"
    t.string   "browser_version"
    t.integer  "lock_version"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "browsers", :force => true do |t|
    t.string   "browser_name"
    t.integer  "lock_version"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "data_updated_dates", :force => true do |t|
    t.string   "data_key"
    t.datetime "data_update_time"
    t.integer  "lock_version"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "domains", :force => true do |t|
    t.string   "domain_name"
    t.integer  "domain_class"
    t.datetime "date_confirmed"
    t.string   "remarks"
    t.boolean  "delete_flg"
    t.integer  "lock_version"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "functions", :force => true do |t|
    t.integer  "system_id"
    t.string   "function_path"
    t.string   "function_name"
    t.integer  "lock_version"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "regulation_cookies", :force => true do |t|
    t.integer  "system_id"
    t.text     "cookie"
    t.string   "remarks"
    t.integer  "lock_version"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "regulation_hosts", :force => true do |t|
    t.integer  "system_id"
    t.string   "proxy_host"
    t.string   "proxy_ip_address"
    t.string   "remote_host"
    t.string   "ip_address"
    t.string   "remarks"
    t.integer  "lock_version"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "regulation_referrers", :force => true do |t|
    t.integer  "system_id"
    t.text     "referrer"
    t.string   "remarks"
    t.integer  "lock_version"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "request_analysis_results", :force => true do |t|
    t.integer  "system_id"
    t.integer  "request_analysis_schedule_id"
    t.integer  "received_year"
    t.integer  "received_month"
    t.integer  "received_day"
    t.integer  "received_hour"
    t.integer  "received_minute"
    t.integer  "received_second"
    t.integer  "function_id"
    t.integer  "function_transition_no"
    t.string   "session_id"
    t.string   "client_id"
    t.integer  "browser_id"
    t.integer  "browser_version_id"
    t.string   "accept_language"
    t.string   "referrer"
    t.integer  "domain_id"
    t.string   "proxy_host"
    t.string   "proxy_ip_address"
    t.string   "remote_host"
    t.string   "ip_address"
    t.integer  "request_count"
    t.integer  "lock_version"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  create_table "request_analysis_schedules", :force => true do |t|
    t.datetime "gets_start_date"
    t.integer  "system_id"
    t.boolean  "gs_received_year"
    t.boolean  "gs_received_month"
    t.boolean  "gs_received_day"
    t.boolean  "gs_received_hour"
    t.boolean  "gs_received_minute"
    t.boolean  "gs_received_second"
    t.boolean  "gs_function_id"
    t.boolean  "gs_function_transition_no"
    t.boolean  "gs_session_id"
    t.boolean  "gs_client_id"
    t.boolean  "gs_browser_id"
    t.boolean  "gs_browser_version_id"
    t.boolean  "gs_accept_language"
    t.boolean  "gs_referrer"
    t.boolean  "gs_domain_id"
    t.boolean  "gs_proxy_host"
    t.boolean  "gs_proxy_ip_address"
    t.boolean  "gs_remote_host"
    t.boolean  "gs_ip_address"
    t.integer  "lock_version"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "systems", :force => true do |t|
    t.string   "system_name"
    t.string   "subsystem_name"
    t.integer  "lock_version"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

end
