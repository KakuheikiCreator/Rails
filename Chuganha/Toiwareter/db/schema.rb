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

  create_table "authorities", :force => true do |t|
    t.string   "authority_cls"
    t.string   "authority"
    t.string   "authority_simple"
    t.integer  "lock_version"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "bbs", :force => true do |t|
    t.string   "bbs_name"
    t.integer  "lock_version"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
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

  create_table "comment_deletes", :force => true do |t|
    t.integer  "quote_id"
    t.integer  "quote_history_id"
    t.integer  "seq_no"
    t.text     "comment"
    t.integer  "critic_id"
    t.string   "critic_member_id"
    t.datetime "criticism_date"
    t.integer  "delete_reason_id"
    t.string   "delete_reason_detail"
    t.integer  "deleted_id"
    t.string   "delete_member_id"
    t.integer  "lock_version"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  create_table "comment_reports", :force => true do |t|
    t.integer  "quote_id"
    t.integer  "quote_history_id"
    t.integer  "comment_id"
    t.integer  "comment_delete_id"
    t.text     "seq_no"
    t.integer  "report_reason_id"
    t.text     "report_reason_detail"
    t.integer  "whistleblower_id"
    t.string   "report_member_id"
    t.datetime "report_date"
    t.integer  "lock_version"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  create_table "comments", :force => true do |t|
    t.integer  "quote_id"
    t.integer  "seq_no"
    t.text     "comment"
    t.integer  "critic_id"
    t.string   "critic_member_id"
    t.datetime "criticism_date"
    t.integer  "lock_version"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
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

  create_table "delete_reasons", :force => true do |t|
    t.string   "delete_reason"
    t.integer  "lock_version"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
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

  create_table "game_consoles", :force => true do |t|
    t.string   "game_console_name"
    t.integer  "lock_version"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "job_titles", :force => true do |t|
    t.string   "job_title"
    t.integer  "lock_version"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "member_states", :force => true do |t|
    t.string   "member_state_cls"
    t.string   "member_state"
    t.string   "member_state_simple"
    t.integer  "lock_version"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "members", :force => true do |t|
    t.binary   "enc_open_id"
    t.string   "member_id"
    t.integer  "member_state_id"
    t.integer  "authority_id"
    t.binary   "enc_nickname"
    t.binary   "enc_email"
    t.datetime "join_date"
    t.datetime "ineligibility_date"
    t.datetime "last_login_date"
    t.integer  "login_cnt"
    t.integer  "quote_cnt"
    t.integer  "quote_failure_cnt"
    t.integer  "quote_correct_cnt"
    t.integer  "quote_correct_failure_cnt"
    t.integer  "quote_delete_cnt"
    t.integer  "comment_cnt"
    t.integer  "comment_failure_cnt"
    t.integer  "comment_report_cnt"
    t.integer  "were_reported_cnt"
    t.integer  "support_report_cnt"
    t.integer  "lock_version"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "newspapers", :force => true do |t|
    t.string   "newspaper_name"
    t.integer  "lock_version"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "ng_words", :force => true do |t|
    t.string   "ng_word"
    t.string   "replace_word"
    t.string   "replace_count"
    t.integer  "lock_version"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "numbers", :force => true do |t|
    t.string   "number_cls"
    t.string   "number_item"
    t.integer  "number"
    t.integer  "lock_version"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "quote_histories", :force => true do |t|
    t.integer  "quote_id"
    t.integer  "seq_no"
    t.text     "quote"
    t.text     "description"
    t.integer  "source_id"
    t.string   "speaker"
    t.integer  "speaker_job_title_id"
    t.string   "speaker_job_title"
    t.integer  "last_comment_seq_no"
    t.integer  "registrant_id"
    t.string   "registered_member_id"
    t.datetime "registered_date"
    t.integer  "update_id"
    t.string   "update_member_id"
    t.datetime "update_date"
    t.integer  "delete_reason_id"
    t.string   "delete_reason_detail"
    t.integer  "deleted_id"
    t.string   "delete_member_id"
    t.integer  "lock_version"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  create_table "quotes", :force => true do |t|
    t.text     "quote"
    t.text     "description"
    t.integer  "source_id"
    t.string   "speaker"
    t.integer  "speaker_job_title_id"
    t.string   "speaker_job_title"
    t.integer  "last_history_seq_no"
    t.integer  "last_comment_seq_no"
    t.integer  "registrant_id"
    t.string   "registered_member_id"
    t.datetime "registered_date"
    t.integer  "update_id"
    t.string   "update_member_id"
    t.datetime "update_date"
    t.integer  "lock_version"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  create_table "reason_corrections", :force => true do |t|
    t.string   "update_reason"
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

  create_table "report_reasons", :force => true do |t|
    t.string   "report_reason"
    t.integer  "lock_version"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
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

  create_table "sns", :force => true do |t|
    t.string   "sns_name"
    t.integer  "lock_version"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "source_bbs", :force => true do |t|
    t.integer  "source_id"
    t.integer  "quote_id"
    t.string   "bbs_id"
    t.string   "bbs_detail_name"
    t.integer  "thread_title"
    t.datetime "posted_date"
    t.string   "posted_by"
    t.string   "quoted_source_url"
    t.integer  "lock_version"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "source_blogs", :force => true do |t|
    t.integer  "source_id"
    t.integer  "quote_id"
    t.string   "blog_name"
    t.string   "article_title"
    t.datetime "posted_date"
    t.string   "posted_by"
    t.integer  "job_title_id"
    t.string   "job_title"
    t.string   "quoted_source_url"
    t.integer  "lock_version"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "source_books", :force => true do |t|
    t.integer  "source_id"
    t.integer  "quote_id"
    t.string   "isbn"
    t.string   "book_title"
    t.string   "publisher"
    t.date     "release_date"
    t.string   "author"
    t.integer  "job_title_id"
    t.string   "job_title"
    t.integer  "lock_version"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "source_games", :force => true do |t|
    t.integer  "source_id"
    t.integer  "quote_id"
    t.string   "title"
    t.integer  "game_console_id"
    t.string   "game_console_dtl_name"
    t.string   "sold_by"
    t.date     "release_date"
    t.integer  "lock_version"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  create_table "source_history_bbs", :force => true do |t|
    t.integer  "source_id"
    t.integer  "quote_history_id"
    t.string   "bbs_id"
    t.string   "bbs_detail_name"
    t.integer  "thread_title"
    t.datetime "posted_date"
    t.string   "posted_by"
    t.string   "quoted_source_url"
    t.integer  "lock_version"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "source_history_blogs", :force => true do |t|
    t.integer  "source_id"
    t.integer  "quote_history_id"
    t.string   "blog_name"
    t.string   "article_title"
    t.datetime "posted_date"
    t.string   "posted_by"
    t.integer  "job_title_id"
    t.string   "job_title"
    t.string   "quoted_source_url"
    t.integer  "lock_version"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "source_history_books", :force => true do |t|
    t.integer  "source_id"
    t.integer  "quote_history_id"
    t.string   "isbn"
    t.string   "book_title"
    t.string   "publisher"
    t.date     "release_date"
    t.string   "author"
    t.integer  "job_title_id"
    t.string   "job_title"
    t.integer  "lock_version"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "source_history_games", :force => true do |t|
    t.integer  "source_id"
    t.integer  "quote_history_id"
    t.string   "title"
    t.integer  "game_console_id"
    t.string   "game_console_dtl_name"
    t.string   "sold_by"
    t.date     "release_date"
    t.integer  "lock_version"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  create_table "source_history_magazines", :force => true do |t|
    t.integer  "source_id"
    t.integer  "quote_history_id"
    t.string   "magazine_cd"
    t.string   "magazine_name"
    t.string   "article_title"
    t.string   "publisher"
    t.date     "release_date"
    t.string   "reporter"
    t.integer  "job_title_id"
    t.string   "job_title"
    t.integer  "lock_version"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "source_history_movies", :force => true do |t|
    t.integer  "source_id"
    t.integer  "quote_history_id"
    t.string   "title"
    t.string   "production"
    t.string   "sold_by"
    t.date     "release_date"
    t.integer  "lock_version"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "source_history_musics", :force => true do |t|
    t.integer  "source_id"
    t.integer  "quote_history_id"
    t.string   "music_name"
    t.string   "lyricist"
    t.string   "composer"
    t.string   "jasrac_code"
    t.string   "iswc"
    t.integer  "lock_version"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "source_history_news_sites", :force => true do |t|
    t.integer  "source_id"
    t.integer  "quote_history_id"
    t.string   "site_name"
    t.string   "article_title"
    t.datetime "posted_date"
    t.string   "reporter"
    t.integer  "job_title_id"
    t.string   "job_title"
    t.string   "quoted_source_url"
    t.integer  "lock_version"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "source_history_newspapers", :force => true do |t|
    t.integer  "source_id"
    t.integer  "quote_history_id"
    t.integer  "newspaper_id"
    t.string   "newspaper_detail"
    t.date     "posted_date"
    t.string   "newspaper_cls"
    t.string   "headline"
    t.string   "reporter"
    t.integer  "job_title_id"
    t.string   "job_title"
    t.integer  "lock_version"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "source_history_other_sites", :force => true do |t|
    t.integer  "source_id"
    t.integer  "quote_history_id"
    t.string   "site_name"
    t.string   "page_name"
    t.string   "posts_by"
    t.integer  "job_title_id"
    t.string   "job_title"
    t.datetime "posted_date"
    t.string   "quoted_source_url"
    t.integer  "lock_version"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "source_history_others", :force => true do |t|
    t.integer  "source_id"
    t.integer  "quote_history_id"
    t.string   "media_name"
    t.integer  "lock_version"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "source_history_radios", :force => true do |t|
    t.integer  "source_id"
    t.integer  "quote_history_id"
    t.string   "program_name"
    t.datetime "broadcast_date"
    t.string   "production"
    t.string   "radio_station"
    t.integer  "lock_version"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "source_history_sns", :force => true do |t|
    t.integer  "source_id"
    t.integer  "quote_history_id"
    t.integer  "sns_id"
    t.string   "sns_detail_name"
    t.datetime "posted_date"
    t.string   "posted_by"
    t.integer  "job_title_id"
    t.string   "job_title"
    t.integer  "lock_version"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "source_history_tvs", :force => true do |t|
    t.integer  "source_id"
    t.integer  "quote_history_id"
    t.string   "program_name"
    t.datetime "broadcast_date"
    t.string   "production"
    t.string   "tv_station"
    t.integer  "lock_version"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "source_history_twitters", :force => true do |t|
    t.integer  "source_id"
    t.integer  "quote_history_id"
    t.datetime "posted_date"
    t.string   "posted_by"
    t.integer  "job_title_id"
    t.string   "job_title"
    t.string   "quoted_source_url"
    t.integer  "lock_version"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "source_magazines", :force => true do |t|
    t.integer  "source_id"
    t.integer  "quote_id"
    t.string   "magazine_cd"
    t.string   "magazine_name"
    t.string   "article_title"
    t.string   "publisher"
    t.date     "release_date"
    t.string   "reporter"
    t.integer  "job_title_id"
    t.string   "job_title"
    t.integer  "lock_version"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "source_movies", :force => true do |t|
    t.integer  "source_id"
    t.integer  "quote_id"
    t.string   "title"
    t.string   "production"
    t.string   "sold_by"
    t.date     "release_date"
    t.integer  "lock_version"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "source_musics", :force => true do |t|
    t.integer  "source_id"
    t.integer  "quote_id"
    t.string   "music_name"
    t.string   "lyricist"
    t.string   "composer"
    t.string   "jasrac_code"
    t.string   "iswc"
    t.integer  "lock_version"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "source_news_sites", :force => true do |t|
    t.integer  "source_id"
    t.integer  "quote_id"
    t.string   "site_name"
    t.string   "article_title"
    t.datetime "posted_date"
    t.string   "reporter"
    t.integer  "job_title_id"
    t.string   "job_title"
    t.string   "quoted_source_url"
    t.integer  "lock_version"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "source_newspapers", :force => true do |t|
    t.integer  "source_id"
    t.integer  "quote_id"
    t.integer  "newspaper_id"
    t.string   "newspaper_detail"
    t.date     "posted_date"
    t.string   "newspaper_cls"
    t.string   "headline"
    t.string   "reporter"
    t.integer  "job_title_id"
    t.string   "job_title"
    t.integer  "lock_version"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "source_other_sites", :force => true do |t|
    t.integer  "source_id"
    t.integer  "quote_id"
    t.string   "site_name"
    t.string   "page_name"
    t.string   "posts_by"
    t.integer  "job_title_id"
    t.string   "job_title"
    t.datetime "posted_date"
    t.string   "quoted_source_url"
    t.integer  "lock_version"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "source_others", :force => true do |t|
    t.integer  "source_id"
    t.integer  "quote_id"
    t.string   "media_name"
    t.integer  "lock_version"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "source_radios", :force => true do |t|
    t.integer  "source_id"
    t.integer  "quote_id"
    t.string   "program_name"
    t.datetime "broadcast_date"
    t.string   "production"
    t.string   "radio_station"
    t.integer  "lock_version"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "source_sns", :force => true do |t|
    t.integer  "source_id"
    t.integer  "quote_id"
    t.integer  "sns_id"
    t.string   "sns_detail_name"
    t.datetime "posted_date"
    t.string   "posted_by"
    t.integer  "job_title_id"
    t.string   "job_title"
    t.integer  "lock_version"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "source_tvs", :force => true do |t|
    t.integer  "source_id"
    t.integer  "quote_id"
    t.string   "program_name"
    t.datetime "broadcast_date"
    t.string   "production"
    t.string   "tv_station"
    t.integer  "lock_version"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "source_twitters", :force => true do |t|
    t.integer  "source_id"
    t.integer  "quote_id"
    t.datetime "posted_date"
    t.string   "posted_by"
    t.integer  "job_title_id"
    t.string   "job_title"
    t.string   "quoted_source_url"
    t.integer  "lock_version"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "sources", :force => true do |t|
    t.string   "source"
    t.integer  "lock_version"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "systems", :force => true do |t|
    t.string   "system_name"
    t.string   "subsystem_name"
    t.integer  "lock_version"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

end
