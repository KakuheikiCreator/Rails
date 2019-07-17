# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：関連項目存在バリデータクラス
# Copyright:: Copyright (c) 2011 仲務省
# 作成日:2012/01/24 Nakanohito  (mailto:)
# 更新日:
###############################################################################
require 'test_helper'
require 'unit/unit_test_util'
require 'validators/any_exists_validator'

class AnyExistsValidatorTest < ActiveSupport::TestCase
  include UnitTestUtil

  # テスト対象メソッド：validate_each
  test "CASE:2-1 validate_each" do
    begin
      # 正常ケース(全項目値有り)
      test_model = TestModel.new
      test_model.test_item1 = 'test value 1'
      test_model.test_item2 = 'test value 2'
      test_model.test_item3 = 'test value 3'
      assert(test_model.valid?, "CASE:2-1-1")
      # 正常ケース(２項目値有り)
      test_model = TestModel.new
      test_model.test_item1 = 'test value 1'
      test_model.test_item2 = nil
      test_model.test_item3 = 'test value 3'
      assert(test_model.valid?, "CASE:2-1-2")
      # 正常ケース(１項目値有り)
      test_model = TestModel.new
      test_model.test_item1 = nil
      test_model.test_item2 = nil
      test_model.test_item3 = 'test value 3'
      assert(test_model.valid?, "CASE:2-1-3")
      # 正常ケース(対象項目がnil)
      test_model = TestModel_2.new
      test_model.test_item1 = nil
      test_model.test_item2 = nil
      test_model.test_item3 = nil
      assert(test_model.valid?, "CASE:2-1-4")
      # 正常ケース(対象項目が空文字)
      test_model = TestModel_2.new
      test_model.test_item1 = ''
      test_model.test_item2 = nil
      test_model.test_item3 = nil
      assert(test_model.valid?, "CASE:2-1-5")
      # エラーケース(nil)
      test_model = TestModel.new
      test_model.test_item1 = nil
      test_model.test_item2 = nil
      test_model.test_item3 = nil
      assert(test_model.valid? == false, "CASE:2-1-6-1")
      test_model.errors.each do |attr, msg|
        error_log("#{attr}:#{msg.to_s}")
        assert(msg.to_s == ",test_item2,test_item3の何れかを入力してください。", "CASE:2-1-6-2")
      end
      # エラーケース(空文字設定)
      test_model = TestModel.new
      test_model.test_item1 = ''
      test_model.test_item2 = ''
      test_model.test_item3 = ''
      assert(test_model.valid? == false, "CASE:2-1-7-1")
      test_model.errors.each do |attr, msg|
#        error_log("#{attr}:#{msg.to_s}")
        assert(msg.to_s == ",test_item2,test_item3の何れかを入力してください。", "CASE:2-1-7-2")
      end
      # エラーケース(nil,空文字混在)
      test_model = TestModel.new
      test_model.test_item1 = ''
      test_model.test_item2 = nil
      test_model.test_item3 = nil
      assert(test_model.valid? == false, "CASE:2-1-8-1")
      test_model.errors.each do |attr, msg|
#        error_log("#{attr}:#{msg.to_s}")
        assert(msg.to_s == ",test_item2,test_item3の何れかを入力してください。", "CASE:2-1-8-2")
      end
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
    attr_accessor :test_item1, :test_item2, :test_item3
    
    ###########################################################################
    # バリデーション定義
    ###########################################################################
    validates :test_item1,
      :any_exists => {:items => [:test_item2, :test_item3]}
    
    ###########################################################################
    # メソッド定義
    ###########################################################################
    # 初期化メソッド
    def initialize
      @test_item1 = nil
      @test_item2 = nil
      @test_item3 = nil
    end
    
    public
    def persisted?
      return false
    end
    # 項目ハッシュアクセサー
    def attributes
      return AttributeHash.new(self)
    end
    
    # 項目名称取得
    def self.human_attribute_name(item_name)
      return item_name
    end
  end
  # :allow_nil=>true
  class TestModel_2
    include ActiveModel::Conversion
    include ActiveModel::Validations
    include Validators
    extend ActiveModel::Naming
    ###########################################################################
    # 項目定義
    ###########################################################################
    attr_accessor :test_item1, :test_item2, :test_item3
    
    ###########################################################################
    # バリデーション定義
    ###########################################################################
    validates :test_item1,
      :any_exists => {:allow_nil=>true,
                      :items => [:test_item2, :test_item3]}
    
    ###########################################################################
    # メソッド定義
    ###########################################################################
    # 初期化メソッド
    def initialize
      @test_item1 = nil
      @test_item2 = nil
      @test_item3 = nil
    end
    
    public
    def persisted?
      return false
    end
    # 項目ハッシュアクセサー
    def attributes
      return AttributeHash.new(self)
    end
    
    # 項目名称取得
    def self.human_attribute_name(item_name)
      return item_name
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
end
