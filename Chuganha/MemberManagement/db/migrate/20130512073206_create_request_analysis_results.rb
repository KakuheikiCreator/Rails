class CreateRequestAnalysisResults < ActiveRecord::Migration
  def change
    create_table :request_analysis_results do |t|
      t.integer :system_id
      t.integer :request_analysis_schedule_id
      t.integer :received_year
      t.integer :received_month
      t.integer :received_day
      t.integer :received_hour
      t.integer :received_minute
      t.integer :received_second
      t.integer :function_id
      t.integer :function_transition_no
      t.string :session_id
      t.string :client_id
      t.integer :browser_id
      t.integer :browser_version_id
      t.string :accept_language
      t.string :referrer
      t.integer :domain_id
      t.string :proxy_host
      t.string :proxy_ip_address
      t.string :remote_host
      t.string :ip_address
      t.integer :request_count
      t.integer :lock_version

      t.timestamps
    end
  end
end
