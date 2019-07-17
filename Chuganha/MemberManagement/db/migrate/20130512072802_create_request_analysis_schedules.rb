class CreateRequestAnalysisSchedules < ActiveRecord::Migration
  def change
    create_table :request_analysis_schedules do |t|
      t.datetime :gets_start_date
      t.integer :system_id
      t.boolean :gs_received_year
      t.boolean :gs_received_month
      t.boolean :gs_received_day
      t.boolean :gs_received_hour
      t.boolean :gs_received_minute
      t.boolean :gs_received_second
      t.boolean :gs_function_id
      t.boolean :gs_function_transition_no
      t.boolean :gs_session_id
      t.boolean :gs_client_id
      t.boolean :gs_browser_id
      t.boolean :gs_browser_version_id
      t.boolean :gs_accept_language
      t.boolean :gs_referrer
      t.boolean :gs_domain_id
      t.boolean :gs_proxy_host
      t.boolean :gs_proxy_ip_address
      t.boolean :gs_remote_host
      t.boolean :gs_ip_address
      t.integer :lock_version

      t.timestamps
    end
  end
end
