# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：関連項目値のマッチングバリデータクラス
# Copyright:: Copyright (c) 2011 仲務省
# 作成日:2012/01/25 Nakanohito  (mailto:)
# 更新日:
###############################################################################
require 'test_helper'
require 'unit/unit_test_util'
require 'validators/matching_relations_validator'

class MatchingRelationsValidatorTest < ActiveSupport::TestCase
  include UnitTestUtil

  # テスト対象メソッド：validate_each
  test "CASE:2-1 validate_each" do
    begin
      # 正常ケース(ホワイトリスト)
      test_model = TestModel.new
      test_model.test_item1 = 'test value 1'
      test_model.test_item2 = 1
      test_model.test_item3 = nil
      test_model.test_item4 = 'b'
      test_model.test_item5 = 1
      test_model.test_item6 = 1
      test_model.test_item7 = 1
      test_model.test_item8 = 3
      assert(test_model.valid?, "CASE:2-1-1")
      test_model.test_item1 = 100
      test_model.test_item2 = 2
      assert(test_model.valid?, "CASE:2-1-2")
      test_model.test_item1 = nil
      test_model.test_item2 = 3
      assert(test_model.valid?, "CASE:2-1-3")
      test_model.test_item1 = 'test value 1'
      test_model.test_item2 = 0
      assert(!test_model.valid?, "CASE:2-1-4")
      # 正常ケース(ブラックリスト)
      test_model = TestModel.new
      test_model.test_item1 = 'test value 1'
      test_model.test_item2 = 1
      test_model.test_item3 = nil
      test_model.test_item4 = 'b'
      test_model.test_item5 = 1
      test_model.test_item6 = 1
      test_model.test_item7 = 1
      test_model.test_item8 = 3
      assert(test_model.valid?, "CASE:2-1-5")
      test_model.test_item3 = 1
      test_model.test_item4 = 'a'
      assert(test_model.valid?, "CASE:2-1-6")
      test_model.test_item3 = nil
      test_model.test_item4 = 'a'
      assert(!test_model.valid?, "CASE:2-1-7")
      # 正常ケース(not nullチェック)
      test_model = TestModel.new
      test_model.test_item1 = 'test value 1'
      test_model.test_item2 = 1
      test_model.test_item3 = nil
      test_model.test_item4 = 'b'
      test_model.test_item5 = 1
      test_model.test_item6 = 1
      test_model.test_item7 = 1
      test_model.test_item8 = 3
      assert(test_model.valid?, "CASE:2-1-8")
      test_model.test_item5 = 1
      test_model.test_item6 = nil
      assert(!test_model.valid?, "CASE:2-1-9")
      # 正常ケース(範囲指定)
      test_model = TestModel.new
      test_model.test_item1 = 'test value 1'
      test_model.test_item2 = 1
      test_model.test_item3 = nil
      test_model.test_item4 = 'b'
      test_model.test_item5 = 1
      test_model.test_item6 = 1
      test_model.test_item7 = 1
      test_model.test_item8 = 3
      assert(test_model.valid?, "CASE:2-1-10")
      test_model.test_item7 = 2
      test_model.test_item8 = 4
      assert(test_model.valid?, "CASE:2-1-11")
      test_model.test_item7 = 3
      test_model.test_item8 = 5
      assert(test_model.valid?, "CASE:2-1-12")
      test_model.test_item7 = 1
      test_model.test_item8 = 2
      assert(!test_model.valid?, "CASE:2-1-13")
      test_model.test_item7 = 1
      test_model.test_item8 = 6
      assert(!test_model.valid?, "CASE:2-1-14")
      test_model.errors.each do |attr, msg|
#        error_log("#{attr}:#{msg.to_s}")
        assert(msg.to_s == "test_item8との整合性に問題があります。", "CASE:2-1-14")
      end
      # 
      test_model = TestModel.new
      test_model.test_item1 = 'test value 1'
      test_model.test_item2 = 1
      test_model.test_item3 = nil
      test_model.test_item4 = 'b'
      test_model.test_item5 = 1
      test_model.test_item6 = 1
      test_model.test_item7 = 1
      test_model.test_item8 = 3
      test_model.test_item9 = 1
      test_model.test_item10 = 'a'
      assert(test_model.valid?, "CASE:2-1-15")
      test_model.test_item9 = 1
      test_model.test_item10 = 'b'
      assert(!test_model.valid?, "CASE:2-1-16")
      # 
      test_model = TestModel.new
      test_model.test_item1 = 'test value 1'
      test_model.test_item2 = 1
      test_model.test_item3 = nil
      test_model.test_item4 = 'b'
      test_model.test_item5 = 1
      test_model.test_item6 = 1
      test_model.test_item7 = 1
      test_model.test_item8 = 3
      test_model.test_item9 = 1
      test_model.test_item10 = 'a'
      test_model.test_item11 = 1
      test_model.test_item12 = 'a'
      assert(test_model.valid?, "CASE:2-1-17")
      test_model.test_item9 = 1
      test_model.test_item10 = 'b'
      assert(!test_model.valid?, "CASE:2-1-18")
      # エラーケース
    rescue StandardError => ex
      print_log("Exception:" + ex.class.name)
      print_log("Message  :" + ex.message)
      print_log("Backtrace:" + ex.backtrace.join("\n"))
      flunk("2-1")
    end
  end
  
  #############################################################################
  # テスト用モデル
  #############################################################################
  class TestModel
    include ActiveModel::Conversion
    include ActiveModel::Validations
    include Validators
    extend ActiveModel::Naming
    ###########################################################################
    # 項目定義
    ###########################################################################
    attr_accessor :test_item1, :test_item2, # 関連項目：ホワイトリスト
                  :test_item3, :test_item4, # 関連項目：ブラックリスト
                  :test_item5, :test_item6, # 関連項目：NULL判定
                  :test_item7, :test_item8, # 
                  :test_item9, :test_item10, # 
                  :test_item11, :test_item12 # 
    
    ###########################################################################
    # バリデーション定義
    ###########################################################################
    # ホワイトリスト
    validates :test_item1,
      :matching_relations => {:values=>:all,
                              :item=>:test_item2,
                              :in=>[1,2,3]}
    # ブラックリスト
    validates :test_item3,
      :matching_relations => {:values=>:null,
                              :item=>:test_item4,
                              :ex=>{:null=>'a'}}
    # NULL判定
    validates :test_item5,
      :matching_relations => {:values=>:not_null,
                              :item=>:test_item6}
    # 複数値
    validates :test_item7,
      :matching_relations => {:values=>[1,2,3],
                              :item=>:test_item8,
                              :in=>3..5}
    # 複数値
    validates :test_item9,
      :matching_relations => {:values=>:not_null,
                              :item=>:test_item10,
                              :in=>{:not_null=>'a'}}
    # 複数値
    validates :test_item11,
      :matching_relations => {:values=>:not_null,
                              :item=>:test_item12,
                              :in=>{1=>'a'}}
    
    ###########################################################################
    # メソッド定義
    ###########################################################################
    def persisted?
      return false
    end
    # 項目ハッシュアクセサー
    def attributes
      return AttributeHash.new(self)
    end
    # クラス取得
    def class
      return DummyClass.new
    end
  end
  class AttributeHash
    # コンストラクタ
    def initialize(obj)
      @obj = obj
    end
    def [](key)
      return @obj.__send__(key)
    end
  end
  class DummyClass
    # 項目名称取得
    def human_attribute_name(item_name)
      return item_name
    end
  end
end
