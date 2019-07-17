# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：ホスト名バリデーター
# Copyright:: Copyright (c) 2011 仲務省
# 作成日:2012/01/23 Nakanohito  (mailto:)
# 更新日:
###############################################################################
require 'test_helper'
require 'unit/unit_test_util'
require 'validators/host_name_validator'

class HostNameValidatorTest < ActiveSupport::TestCase
  include UnitTestUtil

  # テスト対象メソッド：validate_each
  test "CASE:2-1 validate_each" do
    # 正常ケース
    test_model = TestModel.new
    test_model.test_item = 'test.host.name'
    assert(test_model.valid?, "CASE:2-1-1")
    # 正常ケース(nil)
    test_model = TestModel.new
    test_model.test_item = nil
    assert(test_model.valid?, "CASE:2-1-2")
    # 正常ケース(空文字)
    test_model = TestModel.new
    test_model.test_item = ''
    assert(test_model.valid?, "CASE:2-1-3")
    # エラーケース
    test_model = TestModel.new
    test_model.test_item = '@.test.host.name'
    assert(test_model.valid? == false, "CASE:2-1-4-1")
    test_model.errors.each do |attr, msg|
#      error_log("#{attr}:#{msg.to_s}")
      assert(msg.to_s == "は不正な値です。", "CASE:2-1-4-2")
    end
    # エラーケース(nil)
    test_model = TestModel_2.new
    test_model.test_item = nil
    assert(test_model.valid? == false, "CASE:2-1-5-1")
    test_model.errors.each do |attr, msg|
#      error_log("#{attr}:#{msg.to_s}")
      assert(msg.to_s == "は不正な値です。", "CASE:2-1-5-2")
    end
    # エラーケース(空文字)
    test_model = TestModel_2.new
    test_model.test_item = nil
    assert(test_model.valid? == false, "CASE:2-1-6-1")
    test_model.errors.each do |attr, msg|
#      error_log("#{attr}:#{msg.to_s}")
      assert(msg.to_s == "は不正な値です。", "CASE:2-1-6-2")
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
    attr_accessor :test_item
    
    ###########################################################################
    # バリデーション定義
    ###########################################################################
    validates :test_item,
      :allow_nil => true,
      :host_name => true
    
    ###########################################################################
    # メソッド定義
    ###########################################################################
    def persisted?
      return false
    end
  end
  # nil値許容しない
  class TestModel_2
    include ActiveModel::Conversion
    include ActiveModel::Validations
    include Validators
    extend ActiveModel::Naming
    ###########################################################################
    # 項目定義
    ###########################################################################
    attr_accessor :test_item
    
    ###########################################################################
    # バリデーション定義
    ###########################################################################
    validates :test_item,
      :host_name => true
    
    ###########################################################################
    # メソッド定義
    ###########################################################################
    def persisted?
      return false
    end
  end
end
