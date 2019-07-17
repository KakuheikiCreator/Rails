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

  create_table "accounts", :force => true do |t|
    t.string   "user_id"
    t.binary   "hsh_password"
    t.integer  "member_state_id"
    t.binary   "enc_authority_cls"
    t.datetime "join_date"
    t.binary   "hsh_temp_password"
    t.integer  "last_auth_seq_no"
    t.integer  "consecutive_failure_cnt"
    t.binary   "enc_last_name"
    t.binary   "enc_first_name"
    t.binary   "enc_yomigana_last"
    t.binary   "enc_yomigana_first"
    t.binary   "enc_gender_cls"
    t.binary   "enc_birth_date"
    t.string   "salt"
    t.boolean  "delete_flg",              :default => false, :null => false
    t.integer  "lock_version",            :default => 0,     :null => false
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
  end

  create_table "authentication_histories", :force => true do |t|
    t.integer  "account_id",                           :null => false
    t.integer  "seq_no",                               :null => false
    t.string   "server_url",                           :null => false
    t.datetime "authentication_date",                  :null => false
    t.boolean  "authentication_result",                :null => false
    t.string   "ip_address",                           :null => false
    t.string   "referer"
    t.string   "user_agent"
    t.integer  "lock_version",          :default => 0, :null => false
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
  end

  create_table "authorities", :force => true do |t|
    t.string   "authority_cls",                   :null => false
    t.string   "authority",                       :null => false
    t.string   "authority_simple",                :null => false
    t.integer  "lock_version",     :default => 0, :null => false
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

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

  create_table "countries", :force => true do |t|
    t.string   "country_name_cd",                :null => false
    t.string   "country_name",                   :null => false
    t.integer  "lock_version",    :default => 0, :null => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  create_table "data_updated_dates", :force => true do |t|
    t.string   "data_key"
    t.datetime "data_update_time"
    t.integer  "lock_version"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "data_updateds", :force => true do |t|
    t.string   "data_key"
    t.integer  "data_update_version"
    t.integer  "lock_version"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
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

  create_table "genders", :force => true do |t|
    t.string   "gender_cls"
    t.string   "gender"
    t.string   "gender_simple"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "languages", :force => true do |t|
    t.string   "lang_name_cd",                     :null => false
    t.string   "lang_name",                        :null => false
    t.string   "name_notation_cls",                :null => false
    t.integer  "lock_version",      :default => 0, :null => false
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  create_table "member_states", :force => true do |t|
    t.string   "member_state_cls",                   :null => false
    t.string   "member_state",                       :null => false
    t.string   "member_state_simple",                :null => false
    t.integer  "lock_version",        :default => 0, :null => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  create_table "mobile_carriers", :force => true do |t|
    t.string   "mobile_carrier_cd",                :null => false
    t.integer  "mobile_domain_no",                 :null => false
    t.string   "mobile_carrier",                   :null => false
    t.string   "domain",                           :null => false
    t.integer  "lock_version",      :default => 0, :null => false
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  create_table "open_id_associations", :force => true do |t|
    t.binary   "server_url"
    t.binary   "secret"
    t.string   "handle"
    t.string   "assoc_type"
    t.integer  "issued"
    t.integer  "lifetime"
    t.integer  "lock_version"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "open_id_nonces", :force => true do |t|
    t.binary   "server_url"
    t.binary   "salt"
    t.string   "timestamp"
    t.integer  "lock_version"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "open_id_requests", :force => true do |t|
    t.string   "token"
    t.text     "parameters"
    t.integer  "lock_version"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "person_withdrawal_states", :force => true do |t|
    t.string   "person_withdrawal_state_cls",                :null => false
    t.string   "person_withdrawal_state",                    :null => false
    t.integer  "lock_version",                :default => 0, :null => false
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
  end

  create_table "person_withdrawals", :force => true do |t|
    t.string   "user_id"
    t.integer  "withdrawal_reason_id"
    t.binary   "enc_withdrawal_reason_dtl"
    t.integer  "person_withdrawal_state_id"
    t.datetime "join_date"
    t.datetime "withdrawal_date"
    t.integer  "member_state_id"
    t.binary   "enc_authority_cls"
    t.binary   "hsh_password"
    t.binary   "hsh_temp_password"
    t.binary   "enc_nickname"
    t.binary   "enc_last_name"
    t.binary   "enc_first_name"
    t.binary   "enc_yomigana_last"
    t.binary   "enc_yomigana_first"
    t.binary   "enc_gender_cls"
    t.binary   "enc_birth_date"
    t.binary   "enc_country_name_cd"
    t.binary   "enc_lang_name_cd"
    t.binary   "enc_timezone_id"
    t.binary   "enc_postcode"
    t.binary   "enc_email"
    t.binary   "enc_mobile_phone_no"
    t.binary   "hsh_mobile_phone_no"
    t.integer  "mobile_carrier_id"
    t.binary   "enc_mobile_email"
    t.binary   "hsh_mobile_email"
    t.binary   "enc_mobile_id_no"
    t.binary   "hsh_mobile_id_no"
    t.binary   "enc_mobile_host"
    t.binary   "hsh_mobile_host"
    t.datetime "last_authentication_date"
    t.boolean  "last_authentication_result"
    t.string   "last_authentication_ip_address"
    t.string   "last_authentication_referer"
    t.string   "last_authentication_user_agent"
    t.string   "salt"
    t.boolean  "delete_flg"
    t.integer  "lock_version"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  create_table "personas", :force => true do |t|
    t.integer  "account_id"
    t.integer  "seq_no"
    t.binary   "enc_nickname"
    t.binary   "enc_country_name_cd"
    t.binary   "enc_lang_name_cd"
    t.binary   "enc_timezone_id"
    t.binary   "enc_postcode"
    t.binary   "enc_email"
    t.binary   "enc_mobile_phone_no"
    t.integer  "mobile_carrier_id"
    t.binary   "enc_mobile_email"
    t.binary   "enc_mobile_id_no"
    t.binary   "enc_mobile_host"
    t.integer  "lock_version",        :default => 0, :null => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
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

  create_table "timezones", :force => true do |t|
    t.string   "timezone_id",                  :null => false
    t.string   "timezone_name"
    t.integer  "lock_version",  :default => 0, :null => false
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  create_table "withdrawal_reasons", :force => true do |t|
    t.string   "withdrawal_reason_cls",                :null => false
    t.string   "withdrawal_reason",                    :null => false
    t.integer  "lock_version",          :default => 0, :null => false
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
  end

end
