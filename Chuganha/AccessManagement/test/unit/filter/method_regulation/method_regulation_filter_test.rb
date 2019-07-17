# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：リクエストメソッドフィルタークラス
# Copyright:: Copyright (c) 2011 仲務省
# 作成日:2012/02/06 Nakanohito
# 更新日:
###############################################################################
require 'filter/method_regulation/method_regulation_filter'
require 'test_helper'
require 'unit/mock/mock_controller'
require 'unit/unit_test_util'

class MethodRegulationFilterTest < ActiveSupport::TestCase
  include Filter::MethodRegulation
  include Mock
  include UnitTestUtil

  # 前処理
  def setup
  end
  # 後処理
  def teardown
  end
  
  # MethodRegulationFilterクラス：フィルタ処理
  test "2-1:MethodRegulationFilter Test:filter" do
    ############################################################################
    # テスト項目：規制対象外メソッド
    ############################################################################
    begin
      # コントローラ生成
      params = {:controller_name => 'MockController',
                :method=>:GET,
                :session=>Hash.new}
      mock_controller = MockController.new(params)
      # フィルタ処理実行（GET以外規制）
      filter_obj = MethodRegulationFilter.new(:GET)
      filter_obj.filter(mock_controller)
      redirect_hash = mock_controller.redirect_hash
#      print_log("2-1-1 URL:" + redirect_hash[:url].to_s)
      assert(redirect_hash[:url].nil?, "CASE:2-1-1-1")
      # フィルタ処理実行（GET,POST以外規制）
      filter_obj = MethodRegulationFilter.new([:GET, :POST])
      filter_obj.filter(mock_controller)
      redirect_hash = mock_controller.redirect_hash
#      print_log("2-1-1 URL:" + redirect_hash[:url].to_s)
      assert(redirect_hash[:url].nil?, "CASE:2-1-2")
      # フィルタ処理実行（GET,POST以外規制）
      params = {:controller_name => 'MockController',
                :method=>:POST,
                :session=>Hash.new}
      mock_controller = MockController.new(params)
      filter_obj = MethodRegulationFilter.new([:GET, :POST])
      filter_obj.filter(mock_controller)
      redirect_hash = mock_controller.redirect_hash
#      print_log("2-1-1 URL:" + redirect_hash[:url].to_s)
      assert(redirect_hash[:url].nil?, "CASE:2-1-2")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("2-1")
    end
    ############################################################################
    # テスト項目：規制対象メソッド
    ############################################################################
    begin
      # コントローラ生成
      params = {:controller_name => 'MockController',
                :method=>:GET,
                :session=>Hash.new}
      mock_controller = MockController.new(params)
      # フィルタ処理実行（GET以外規制）
      filter_obj = MethodRegulationFilter.new(:POST)
      filter_obj.filter(mock_controller)
      redirect_hash = mock_controller.redirect_hash
#      print_log("2-1-1 URL:" + redirect_hash[:url].to_s)
      assert(redirect_hash[:url] == '/403.html', "CASE:2-1-1-2")
      # フィルタ処理実行（POST, PUT, DELETE以外規制）
      params = {:controller_name => 'MockController',
                :method=>:GET,
                :session=>Hash.new}
      mock_controller = MockController.new(params)
      filter_obj = MethodRegulationFilter.new([:POST, :PUT, :DELETE])
      filter_obj.filter(mock_controller)
      redirect_hash = mock_controller.redirect_hash
#      print_log("2-1-1 URL:" + redirect_hash[:url].to_s)
      assert(redirect_hash[:url] == '/403.html', "CASE:2-1-2")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("2-1")
    end
    ############################################################################
    # テスト項目：規制判定フラグオフ
    ############################################################################
    begin
      # コントローラ生成
      params = {:controller_name => 'MockController',
                :method=>:GET,
                :session=>Hash.new}
      mock_controller = MockController.new(params)
      # メソッド規制オフ
      mock_controller.flash[:redirect_flg] = true
      # フィルタ処理実行（GET以外規制）
      filter_obj = MethodRegulationFilter.new(:POST)
      filter_obj.filter(mock_controller)
      redirect_hash = mock_controller.redirect_hash
#      print_log("2-1-1 URL:" + redirect_hash[:url].to_s)
      assert(redirect_hash[:url].nil?, "CASE:2-1-3")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("2-1-3")
    end
  end
end
