# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：アクセス規制フィルタークラス
# Copyright:: Copyright (c) 2011 仲務省
# 作成日:2012/01/22 Nakanohito
# 更新日:
###############################################################################
require 'test_helper'
require 'unit/mock/mock_controller'
require 'unit/unit_test_util'
require 'data_cache/system_cache'
require 'filter/access_regulation/access_regulation_filter'

class AccessRegulationFilterTest < ActiveSupport::TestCase
  include DataCache
  include Filter::AccessRegulation
  include Mock
  include UnitTestUtil

  # 前処理
  def setup
    # 業務設定
    @biz_config = Business::BizCommon::BusinessConfig.instance
    # 設定情報ロード
    SystemCache.instance.data_load
  end
  # 後処理
  def teardown
  end
  
  # AccessRegulationFilterクラス：フィルタ処理（正常）
  test "2-1-1=>2-1-2:AccessRegulationFilter Test:filter Normal" do
    ############################################################################
    # テスト変数
    ############################################################################
    filter_obj = AccessRegulationFilter.new
    ############################################################################
    # テスト項目：規制対象外
    ############################################################################
    client = ['client.ok.ne.jp', '255.168.255.1']
    proxy = ['proxy.ok.ne.jp', '255.168.254.1']
    referrer = 'test.normal.referrer.com'
    cookie = 'test nomal cookie'
    begin
      # コントローラ生成
      params = {:controller_name => 'MockController',
                :method=>:get,
                :session=>Hash.new}
      mock_controller = MockController.new(params)
      # リクエスト生成
      request = mock_controller.request
      request.headers['REMOTE_HOST'] = client[0]
      request.headers['REMOTE_ADDR'] = client[1]
      request.headers['HTTP_SP_HOST'] = proxy[0]
      request.headers['HTTP_CLIENT_IP'] = proxy[1]
      filter_obj.filter(mock_controller)
      redirect_hash = mock_controller.redirect_hash
      assert(redirect_hash.size == 0, "CASE:2-1-1")
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("2-1-1")
    end
    begin
      # コントローラ生成
      params = {:controller_name => 'MockController',
                :method=>:get,
                :session=>Hash.new}
      mock_controller = MockController.new(params)
      # リクエスト生成
      request = mock_controller.request
      request.headers['REMOTE_HOST'] = client[0]
      request.headers['REMOTE_ADDR'] = client[1]
      request.headers['HTTP_SP_HOST'] = proxy[0]
      request.headers['HTTP_CLIENT_IP'] = proxy[1]
      request.headers['HTTP_REFERER'] = referrer
      request.headers['HTTP_COOKIE'] = cookie
      filter_obj.filter(mock_controller)
      redirect_hash = mock_controller.redirect_hash
      assert(redirect_hash.size == 0, "CASE:2-1-2")
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("2-1-2")
    end
  end
  
  # AccessRegulationFilterクラス：フィルタ処理（ホスト規制）
  test "2-1-3=>2-1-4:AccessRegulationFilter Test:filter Host" do
    ############################################################################
    # テスト項目：規制対象外
    ############################################################################
    client = ['client.ok.ne.jp', '255.168.255.1']
    proxy = ['proxy.ok.ne.jp', '255.168.254.1']
    referrer = 'test.normal.referrer.com'
    cookie = 'test nomal cookie'
    ############################################################################
    # テスト項目：ホスト規制
    ############################################################################
    reg_client = ['reg.client.ne.jp', '255.255.255.1']
    # プロキシ未使用
    begin
      # コントローラ生成
      params = {:controller_name => 'MockController',
                :method=>:get,
                :session=>Hash.new}
      mock_controller = MockController.new(params)
      # リクエスト生成
      request = mock_controller.request
      request.headers['REMOTE_HOST'] = reg_client[0]
      request.headers['REMOTE_ADDR'] = reg_client[1]
      filter_obj = AccessRegulationFilter.new
      filter_obj.filter(mock_controller)
#      redirect_hash = mock_controller.redirect_hash
#      print_log("2-1-3 URL:" + redirect_hash[:url].to_s)
#      assert(redirect_hash[:url].nil?, "CASE:2-1-3-0")
#      assert(redirect_hash[:url] == '/403.html', "CASE:2-1-3-1")
#      assert(redirect_hash[:status] == 403, "CASE:2-1-3-2")
      print_log("CASE:2-1-3 HTTP STATUS:" + mock_controller.http_status.to_s)
      assert(mock_controller.http_status == :forbidden, "CASE:2-1-3")
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("2-1-3")
    end
    # プロキシ使用
    begin
      # コントローラ生成
      params = {:controller_name => 'MockController',
                :method=>:get,
                :session=>Hash.new}
      mock_controller = MockController.new(params)
      # リクエスト生成
      request = mock_controller.request
      request.headers['REMOTE_HOST'] = proxy[0]
      request.headers['REMOTE_ADDR'] = proxy[1]
      request.headers['HTTP_SP_HOST'] = reg_client[0]
      request.headers['HTTP_CLIENT_IP'] = reg_client[1]
      filter_obj = AccessRegulationFilter.new
      filter_obj.filter(mock_controller)
#      redirect_hash = mock_controller.redirect_hash
#      assert(redirect_hash[:url] == '/403.html', "CASE:2-1-4-1")
#      assert(redirect_hash[:status] == 403, "CASE:2-1-4-2")
      print_log("CASE:2-1-4 HTTP STATUS:" + mock_controller.http_status.to_s)
      assert(mock_controller.http_status == :forbidden, "CASE:2-1-4")
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("2-1-4")
    end
  end
  
  # AccessRegulationFilterクラス：フィルタ処理（リファラー規制）
  test "2-1-5:AccessRegulationFilter Test:filter Referrer" do
    ############################################################################
    # テスト項目：規制対象外
    ############################################################################
    client = ['client.ok.ne.jp', '255.168.255.1']
    proxy = ['proxy.ok.ne.jp', '255.168.254.1']
    referrer = 'test.normal.referrer.com'
    cookie = 'test nomal cookie'
    ############################################################################
    # テスト項目：リファラー規制
    ############################################################################
    reg_referrer = 'www.yahoo.co.jp'
    # 規制リファラー
    begin
      # コントローラ生成
      params = {:controller_name => 'MockController',
                :method=>:get,
                :session=>Hash.new}
      mock_controller = MockController.new(params)
      # リクエスト生成
      request = mock_controller.request
      request.headers['REMOTE_HOST'] = client[0]
      request.headers['REMOTE_ADDR'] = client[1]
      request.headers['HTTP_REFERER'] = reg_referrer
      filter_obj = AccessRegulationFilter.new
      filter_obj.filter(mock_controller)
#      redirect_hash = mock_controller.redirect_hash
#      assert(redirect_hash[:url].nil?, "CASE:2-1-6-0")
#      assert(redirect_hash[:url] == '/403.html', "CASE:2-1-5-1")
#      assert(redirect_hash[:status] == 403, "CASE:2-1-5-2")
      print_log("CASE:2-1-5 HTTP STATUS:" + mock_controller.http_status.to_s)
      assert(mock_controller.http_status == :forbidden, "CASE:2-1-5")
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("2-1-5")
    end
  end
  
  # AccessRegulationFilterクラス：フィルタ処理（クッキー規制）
  test "2-1-6:AccessRegulationFilter Test:filter Cookie" do
    ############################################################################
    # テスト項目：規制対象外
    ############################################################################
    client = ['client.ok.ne.jp', '255.168.255.1']
    proxy = ['proxy.ok.ne.jp', '255.168.254.1']
    referrer = 'test.normal.referrer.com'
    cookie = 'test nomal cookie'
    ############################################################################
    # テスト項目：クッキー規制
    ############################################################################
    reg_cookie = '2'
    # 規制クッキー
    begin
      # コントローラ生成
      params = {:controller_name => 'MockController',
                :method=>:get,
                :session=>Hash.new}
      mock_controller = MockController.new(params)
      # リクエスト生成
      request = mock_controller.request
      request.headers['REMOTE_HOST'] = client[0]
      request.headers['REMOTE_ADDR'] = client[1]
      request.headers['HTTP_REFERER'] = referrer
      request.headers['HTTP_COOKIE'] = reg_cookie
      filter_obj = AccessRegulationFilter.new
      filter_obj.filter(mock_controller)
#      redirect_hash = mock_controller.redirect_hash
#      assert(redirect_hash[:url] == '/403.html', "CASE:2-1-6-1")
#      assert(redirect_hash[:status] == 403, "CASE:2-1-6-2")
      print_log("CASE:2-1-6 HTTP STATUS:" + mock_controller.http_status.to_s)
      assert(mock_controller.http_status == :forbidden, "CASE:2-1-6")
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("2-1-6")
    end
  end
  
  # AccessRegulationFilterクラス：フィルタ処理（リクエスト頻度規制）
  test "2-1-7:AccessRegulationFilter Test:filter frequency" do
    ############################################################################
    # テスト項目：規制対象外
    ############################################################################
    client = ['client.ok.ne.jp', '255.168.255.1']
    ############################################################################
    # テスト項目：リクエスト頻度規制
    ############################################################################
    begin
      # コントローラ生成
      params = {:controller_name => 'MockController',
                :method=>:get,
                :session=>Hash.new}
      mock_controller = MockController.new(params)
      # リクエスト生成
      request = mock_controller.request
      request.headers['REMOTE_HOST'] = client[0]
      request.headers['REMOTE_ADDR'] = client[1]
      sleep(1)
      filter_obj = AccessRegulationFilter.new
      @biz_config.max_request_frequency.times do
        filter_obj.filter(mock_controller)
        assert(mock_controller.http_status.nil?, "CASE:2-1-7-1")
      end
      filter_obj.filter(mock_controller)
      print_log("CASE:2-1-7 HTTP STATUS:" + mock_controller.http_status.to_s)
      assert(mock_controller.http_status == :forbidden, "CASE:2-1-7-2")
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("2-1-6")
    end
  end
  
  # AccessRegulationFilterクラス：フィルタ処理（リダイレクトによるチェックスルー）
  test "2-1-8:AccessRegulationFilter Test:filter redirect" do
    ############################################################################
    # テスト項目：リダイレクト時のチェック処理スルー
    ############################################################################
    reg_client = ['reg.client.ne.jp', '255.255.255.1']
    # プロキシ未使用
    begin
      # コントローラ生成
      params = {:controller_name => 'MockController',
                :method=>:get,
                :session=>Hash.new}
      mock_controller = MockController.new(params)
      # リクエスト生成
      request = mock_controller.request
      request.headers['REMOTE_HOST'] = reg_client[0]
      request.headers['REMOTE_ADDR'] = reg_client[1]
      mock_controller.flash[:redirect_flg] = true
      AccessRegulationFilter.new.filter(mock_controller)
      print_log("CASE:2-1-8 HTTP STATUS:" + mock_controller.http_status.to_s)
      assert(mock_controller.http_status.nil?, "CASE:2-1-8")
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("2-1-8")
    end
  end
  
  # AccessRegulationFilterクラス：フィルタ処理（パフォーマンス）
  test "3-1:AccessRegulationFilter Test:filter Performance" do
    ############################################################################
    # テスト項目：規制対象外
    ############################################################################
    client = ['client.ok.ne.jp', '255.168.255.1']
    proxy = ['proxy.ok.ne.jp', '255.168.254.1']
    referrer = 'test.normal.referrer.com'
    cookie = 'test nomal cookie'
    begin
      # コントローラ生成
      params = {:controller_name => 'MockController',
                :method=>:get,
                :session=>Hash.new}
      mock_controller = MockController.new(params)
      # リクエスト生成
      request = mock_controller.request
      request.headers['REMOTE_HOST'] = client[0]
      request.headers['REMOTE_ADDR'] = client[1]
      request.headers['HTTP_SP_HOST'] = proxy[0]
      request.headers['HTTP_CLIENT_IP'] = proxy[1]
      request.headers['HTTP_REFERER'] = referrer
      request.headers['HTTP_COOKIE'] = cookie
      # 頻度回数バックアップ・更新
      bak_count = @biz_config.max_request_frequency
#      @biz_config.max_request_frequency = 10000
      @biz_config.instance_variable_set(:@max_request_frequency, 10000)  
      # テスト実行
      filter_obj = AccessRegulationFilter.new
      print_log("Processing Start")
      loop_count = 0
      begin_time = Time.now
      10000.times do
        loop_count += 1
        filter_obj.filter(mock_controller)
      end
      # 頻度回数復旧
#      @biz_config.max_request_frequency = bak_count
      @biz_config.instance_variable_set(:@max_request_frequency, bak_count)  
      execute_time = Time.now - begin_time
      print("Loop count:" + loop_count.to_s + "\n")
      print_log("Loop count:" + loop_count.to_s)
      print("Processing time:" + execute_time.to_s + "s\n")
      print_log("Processing time:" + execute_time.to_s + "s")
      print("check count:" + (loop_count / execute_time).to_s + " chk/s\n")
      print_log("check count:" + (loop_count / execute_time).to_s + " chk/s")
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("3-1")
    end
  end
end
