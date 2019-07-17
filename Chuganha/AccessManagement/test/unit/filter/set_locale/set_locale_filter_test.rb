# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：言語設定フィルタークラス
# Copyright:: Copyright (c) 2011 仲務省
# 作成日:2012/01/23 Nakanohito
# 更新日:
###############################################################################
require 'filter/set_locale/set_locale_filter'
require 'test_helper'
require 'unit/mock/mock_controller'
require 'unit/unit_test_util'

class SetLocaleFilterTest < ActiveSupport::TestCase
  include Filter::SetLocale
  include Mock
  include UnitTestUtil

  # 前処理
  def setup
  end
  # 後処理
  def teardown
  end
  
  # SetLocaleFilterクラス：フィルタ処理
  test "2-1:SetLocaleFilter Test:filter" do
    ############################################################################
    # テスト変数
    ############################################################################
    filter_obj = SetLocaleFilter.new
    ############################################################################
    # テスト項目：規制対象外
    ############################################################################
    begin
      # コントローラ生成
      params = {:controller_name => 'MockController',
                :method=>:get,
                :session=>Hash.new}
      mock_controller = MockController.new(params)
      # リクエスト生成
      request = mock_controller.request
#      print("Locale:" + I18n.locale.class.name + "\n")
      request.headers['Accept-Language'] = "ja"
      filter_obj.filter(mock_controller)
#      print("Locale:" + I18n.locale.class.name + "\n")
      assert(I18n.locale == 'ja'.to_sym, "CASE:2-1-1")
      request.headers['Accept-Language'] = "en"
      filter_obj.filter(mock_controller)
      assert(I18n.locale == 'en'.to_sym, "CASE:2-1-1")
      request.headers['Accept-Language'] = "da"
      filter_obj.filter(mock_controller)
      assert(I18n.locale == 'ja'.to_sym, "CASE:2-1-2")
      request.headers['Accept-Language'] = nil
      filter_obj.filter(mock_controller)
      assert(I18n.locale == 'ja'.to_sym, "CASE:2-1-3")
    rescue StandardError => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("2-1")
    end
  end
end
