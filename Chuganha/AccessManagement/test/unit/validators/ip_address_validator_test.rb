# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：IPアドレスバリデーター
# Copyright:: Copyright (c) 2011 仲務省
# 作成日:2012/01/23 Nakanohito  (mailto:)
# 更新日:
###############################################################################
require 'test_helper'
require 'unit/unit_test_util'
require 'validators/ip_address_validator'

class IpAddressValidatorTest < ActiveSupport::TestCase
  include UnitTestUtil

  # テスト対象メソッド：validate_each
  test "CASE:2-1 validate_each" do
    # 正常ケース
    test_model = TestModel.new
    test_model.test_item = '192.168.254.254'
    assert(test_model.valid?, "CASE:2-1-1")
    test_model.test_item = nil
    assert(test_model.valid?, "CASE:2-1-2")
    test_model.test_item = ''
    assert(test_model.valid?, "CASE:2-1-2")
    # エラーケース
    test_model.test_item = '192.168.254.256'
    assert(test_model.valid? == false, "CASE:2-1-3")
    test_model.errors.each do |attr, msg|
#      error_log("#{attr}:#{msg.to_s}")
      assert(msg.to_s == "は不正な値です。", "CASE:2-1-3")
    end
    # 異常ケース
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
#    @test_item = nil
    
    ###########################################################################
    # バリデーション定義
    ###########################################################################
    validates :test_item,
      :allow_nil => true,
      :ip_address => true
    
    ###########################################################################
    # メソッド定義
    ###########################################################################
    def persisted?
      return false
    end
  end
end
