# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：ビジネスアクションクラス
# コントローラー：AccessTotal::AccessTotalController
# アクション：function
# Copyright:: Copyright (c) 2011 仲務省
# 作成日:2012/10/25 Nakanohito
# 更新日:
###############################################################################
require 'test_helper'
require 'unit/unit_test_util'
require 'unit/mock/mock_controller'
require 'biz_actions/access_total/function_action'

class FunctionActionTest < ActiveSupport::TestCase
  include UnitTestUtil
  include BizActions::AccessTotal
  include Mock
  # 前処理
  def setup
    Time.zone = 3/8
  end
  # 後処理
#  def teardown
#  end

  # 機能コンボ生成アクション
  test "2-1:FunctionAction Test:options_string" do
    ###########################################################################
    # 受信日時リスト生成処理
    ###########################################################################
    # CASE:2-1-1
    # 正常ケース
    # テスト内容：システムID指定、対象データあり
    begin
      params={:controller_name=>'access_total',
              :method=>:POST,
              :session=>{},
              # 線分類
              :params=>{:system_id=>'1'}
             }
      controller = MockController.new(params)
      action = FunctionAction.new(controller)
      # コンストラクタ生成
      assert(!action.nil?, "CASE:2-1-1-1")
      # 集計処理実行
      option_str = action.options_string
      # 生成タグ
      chk_val =  '<option value="">全て</option>'
      chk_val += '<option value="1">アクセス解析</option>'
      chk_val += '<option value="2">リクエスト解析スケジュール一覧</option>'
      chk_val += '<option value="3">モック機能</option>'
      chk_val += '<option value="4">テスト用リクエストデータ</option>'
      chk_val += '<option value="5">セッション更新フィルターテストデータ</option>'
      assert(option_str == chk_val, "CASE:2-1-1-1")
      # エラーメッセージ
#      print_log('error hash:' + action.error_msg_hash.to_s)
      assert(action.error_msg_hash.size == 0, "CASE:2-1-1-2")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-1")
    end
    # CASE:2-1-2
    # 正常ケース
    # テスト内容：システムID指定、対象データなし
    begin
      params={:controller_name=>'access_total',
              :method=>:POST,
              :session=>{},
              # 線分類
              :params=>{:system_id=>'2'}
             }
      controller = MockController.new(params)
      action = FunctionAction.new(controller)
      # コンストラクタ生成
      assert(!action.nil?, "CASE:2-1-1-1")
      # 集計処理実行
      option_str = action.options_string
      # 生成タグ
      chk_val =  '<option value="">全て</option>'
      assert(option_str == chk_val, "CASE:2-1-2-1")
      # エラーメッセージ
#      print_log('error hash:' + action.error_msg_hash.to_s)
      assert(action.error_msg_hash.size == 0, "CASE:2-1-2-2")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-2")
    end
    # CASE:2-1-2
    # 異常ケース
    # テスト内容：システムID指定なし、対象データなし
    begin
      params={:controller_name=>'access_total',
              :method=>:POST,
              :session=>{},
              # 線分類
              :params=>{:system_id=>nil}
             }
      controller = MockController.new(params)
      action = FunctionAction.new(controller)
      # コンストラクタ生成
      assert(!action.nil?, "CASE:2-1-1-1")
      # 集計処理実行
      option_str = action.options_string
      # 生成タグ
      chk_val =  '<option value="">全て</option>'
      assert(option_str == chk_val, "CASE:2-1-3-1")
      # エラーメッセージ
#      print_log('error hash:' + action.error_msg_hash.to_s)
      assert(action.error_msg_hash.size == 0, "CASE:2-1-3-2")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-3")
    end
    # CASE:2-1-2
    # 異常ケース
    # テスト内容：システムID指定あり、属性エラー
    begin
      params={:controller_name=>'access_total',
              :method=>:POST,
              :session=>{},
              # 線分類
              :params=>{:system_id=>'システムID'}
             }
      controller = MockController.new(params)
      action = FunctionAction.new(controller)
      # コンストラクタ生成
      assert(!action.nil?, "CASE:2-1-1-1")
      # 集計処理実行
      option_str = action.options_string
      # 生成タグ
      chk_val =  '<option value="">全て</option>'
      assert(option_str == chk_val, "CASE:2-1-4-1")
      # エラーメッセージ
#      print_log('error hash:' + action.error_msg_hash.to_s)
      assert(action.error_msg_hash.size == 0, "CASE:2-1-4-2")
    rescue => ex
      error_log("Exception:" + ex.class.name)
      error_log("Message  :" + ex.message)
      error_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("CASE:2-1-4")
    end
  end
end