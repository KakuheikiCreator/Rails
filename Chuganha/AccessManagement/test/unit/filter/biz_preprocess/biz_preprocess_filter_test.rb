# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：業務前処理フィルタ
# Copyright:: Copyright (c) 2011 仲務省
# 作成日:2012/07/19 Nakanohito
# 更新日:
###############################################################################
require 'test_helper'
require 'unit/mock/mock_controller'
require 'unit/unit_test_util'
require 'filter/biz_preprocess/biz_preprocess_filter'
# RKVクライアント
require 'rkvi/rkv_client'
# キャッシュデータ
require 'data_cache/regulation_cookie_cache'
require 'data_cache/regulation_host_cache'
require 'data_cache/regulation_referrer_cache'
require 'data_cache/request_analysis_schedule_cache'

class BizPreprocessFilterTest < ActiveSupport::TestCase
  include UnitTestUtil
  include Filter::BizPreprocess
  include Mock
  include DataCache

  # 前処理
  def setup
    # リロード判定（解析情報取得設定キャッシュ）
    @cache_1 = RequestAnalysisScheduleCache.instance
    # リロード判定（規制クッキー情報）
    @cache_2 = RegulationCookieCache.instance
    # リロード判定（規制ホスト情報）
    @cache_3 = RegulationHostCache.instance
    # リロード判定（規制リファラー情報）
    @cache_4 = RegulationReferrerCache.instance
  end
  # 後処理
  def teardown
  end
  
  # フィルタ処理
  test "2-1:filter" do
    ############################################################################
    # 正常ケース
    ############################################################################
    begin
      ##########################################################################
      # テスト項目：初回実行
      # 内容：キャッシュリロードなし、ロード日時ハッシュ更新
      ##########################################################################
      # コントローラ生成
      params = {:controller_name => 'MockController',
                :method=>:GET,
                :session=>Hash.new}
      mock_controller = MockController.new(params)
      # フィルタ生成
      filter_obj = BizPreprocessFilter.new
      updated_at_hash = filter_obj.instance_variable_get(:@updated_at_hash)
      assert(updated_at_hash.size == 0, "CASE:2-1-1")
      # キャッシュロード日時
      loaded_at_1 = @cache_1.loaded_at
      loaded_at_2 = @cache_2.loaded_at
      loaded_at_3 = @cache_3.loaded_at
      loaded_at_4 = @cache_4.loaded_at
      # フィルタ処理実行（GET以外規制）
      filter_obj.filter(mock_controller)
      # 実行結果検証
      assert(updated_at_hash[:request_analysis_schedule] == loaded_at_1, "CASE:2-1-2")
      assert(updated_at_hash[:regulation_cookie] == loaded_at_2, "CASE:2-1-3")
      assert(updated_at_hash[:regulation_host] == loaded_at_3, "CASE:2-1-4")
      assert(updated_at_hash[:regulation_referrer] == loaded_at_4, "CASE:2-1-5")
      # ロード日時
      assert(@cache_1.loaded_at == loaded_at_1, "CASE:2-1-6")
      assert(@cache_2.loaded_at == loaded_at_2, "CASE:2-1-6")
      assert(@cache_3.loaded_at == loaded_at_3, "CASE:2-1-6")
      assert(@cache_4.loaded_at == loaded_at_4, "CASE:2-1-6")
      # ログチェック
      debug_msg_list = mock_controller.logger.debug_msg_list
      assert(debug_msg_list[0] == 'BizPreprocessFilter Execute!!!', "CASE:2-1-8")
      ##########################################################################
      # テスト項目：二回目実行
      # 内容：キャッシュリロードなし、ロード日時ハッシュ更新なし
      ##########################################################################
      # コントローラ生成
      params = {:controller_name => 'MockController',
                :method=>:GET,
                :session=>Hash.new}
      mock_controller = MockController.new(params)
      # フィルタ処理実行（GET以外規制）
      filter_obj.filter(mock_controller)
      # 実行結果検証
      assert(updated_at_hash[:request_analysis_schedule] == loaded_at_1, "CASE:2-1-2")
      assert(updated_at_hash[:regulation_cookie] == loaded_at_2, "CASE:2-1-3")
      assert(updated_at_hash[:regulation_host] == loaded_at_3, "CASE:2-1-4")
      assert(updated_at_hash[:regulation_referrer] == loaded_at_4, "CASE:2-1-5")
      # ロード日時
      assert(@cache_1.loaded_at == loaded_at_1, "CASE:2-1-6")
      assert(@cache_2.loaded_at == loaded_at_2, "CASE:2-1-6")
      assert(@cache_3.loaded_at == loaded_at_3, "CASE:2-1-6")
      assert(@cache_4.loaded_at == loaded_at_4, "CASE:2-1-6")
      # ログチェック
      debug_msg_list = mock_controller.logger.debug_msg_list
      assert(debug_msg_list[0] == 'BizPreprocessFilter Execute!!!', "CASE:2-1-8")
      ##########################################################################
      # テスト項目：三回目実行
      # 内容：キャッシュリロードあり、ロード日時ハッシュ更新なし
      ##########################################################################
      # コントローラ生成
      params = {:controller_name => 'MockController',
                :method=>:GET,
                :session=>Hash.new}
      mock_controller = MockController.new(params)
      # 更新日時アップデート
      update_time = Time.now
      updated_at_hash[:request_analysis_schedule] = update_time
      updated_at_hash[:regulation_cookie] = update_time
      updated_at_hash[:regulation_host] = update_time
      updated_at_hash[:regulation_referrer] = update_time
      # フィルタ処理実行（GET以外規制）
      filter_obj.filter(mock_controller)
      # 実行結果検証
      assert(@cache_1.loaded_at > update_time, "CASE:2-1-7")
      assert(@cache_2.loaded_at > update_time, "CASE:2-1-7")
      assert(@cache_3.loaded_at > update_time, "CASE:2-1-7")
      assert(@cache_4.loaded_at > update_time, "CASE:2-1-7")
      # 実行結果検証
      assert(updated_at_hash[:request_analysis_schedule] == update_time, "CASE:2-1-2")
      assert(updated_at_hash[:regulation_cookie] == update_time, "CASE:2-1-3")
      assert(updated_at_hash[:regulation_host] == update_time, "CASE:2-1-4")
      assert(updated_at_hash[:regulation_referrer] == update_time, "CASE:2-1-5")
      # ログチェック
      debug_msg_list = mock_controller.logger.debug_msg_list
      assert(debug_msg_list[0] == 'BizPreprocessFilter Execute!!!', "CASE:2-1-8")
      ##########################################################################
      # テスト項目：四回目実行
      # 内容：キャッシュリロードなし、ロード日時ハッシュ更新なし
      ##########################################################################
      # コントローラ生成
      params = {:controller_name => 'MockController',
                :method=>:GET,
                :session=>Hash.new}
      mock_controller = MockController.new(params)
      # キャッシュロード日時
      loaded_at_1 = @cache_1.loaded_at
      loaded_at_2 = @cache_2.loaded_at
      loaded_at_3 = @cache_3.loaded_at
      loaded_at_4 = @cache_4.loaded_at
      # フィルタ処理実行（GET以外規制）
      filter_obj.filter(mock_controller)
      # 実行結果検証
      assert(updated_at_hash[:request_analysis_schedule] == update_time, "CASE:2-1-2")
      assert(updated_at_hash[:regulation_cookie] == update_time, "CASE:2-1-3")
      assert(updated_at_hash[:regulation_host] == update_time, "CASE:2-1-4")
      assert(updated_at_hash[:regulation_referrer] == update_time, "CASE:2-1-5")
      # ロード日時
      assert(@cache_1.loaded_at == loaded_at_1, "CASE:2-1-6")
      assert(@cache_2.loaded_at == loaded_at_2, "CASE:2-1-6")
      assert(@cache_3.loaded_at == loaded_at_3, "CASE:2-1-6")
      assert(@cache_4.loaded_at == loaded_at_4, "CASE:2-1-6")
      # ログチェック
      debug_msg_list = mock_controller.logger.debug_msg_list
      assert(debug_msg_list[0] == 'BizPreprocessFilter Execute!!!', "CASE:2-1-7")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("2-1")
    end
  end
end
