# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：受信したリクエスト情報をラッピングし、検証等のビジネスロジックを実装する
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/03/23 Nakanohito
# 更新日:
###############################################################################
require 'date'
require 'common/validation_chk_module'

module BizActions
  class BusinessAction
    include Common::ValidationChkModule
    # リーダー
    attr_reader :controller_path, :controller_name,
                :params, :request, :session,
                :function_state, :function_state_hash,
                :logger, :error_msg_hash
    ###########################################################################
    # コンストラクタ
    ###########################################################################
    def initialize(controller)
      # コントローラー関係
      @controller = controller
      @controller_path = controller.controller_path
      @controller_name = controller.controller_name
      # リクエスト関係
      @request = controller.request
      @params = controller.flash[:params]
      @params ||= controller.params
      # セッション関係
      @session = controller.session
      @function_state_hash = @session[:function_state_hash]
      @function_state = @session[:function_state]
      # バリデーション関係
      @valid_flg = false
      # エラーメッセージ
      @logger = controller.logger
      @error_msg_hash = Hash.new
    end
    ###########################################################################
    # publicメソッド定義
    ###########################################################################
    public
    # 受信情報チェック
    def valid?
      @valid_flg = single_item_chk?     # 単項目チェック
      return false unless @valid_flg
      @valid_flg = related_items_chk?   # 項目関連チェック
      return false unless @valid_flg
      @valid_flg = db_related_chk?      # DB関連チェック
      return @valid_flg
    end
    
    # 定義していないメソッド呼び出しがされた場合
    def method_missing(name, *args, &block)
      # コントローラーのメソッドを実行
      return @controller.__send__(name, *args) if block.nil?
      return @controller.__send__(name, *args, block)
    end
    
    ###########################################################################
    # protectedメソッド定義
    ###########################################################################
    protected
    # 単項目チェック
    def single_item_chk?
      return true
    end
    # 項目関連チェック
    def related_items_chk?
      return true
    end
    # DB関連チェック
    def db_related_chk?
      return true
    end
    # 国際化テキスト生成
    def view_text(key, opts=nil)
      return "" if key.nil?
      return I18n.t('views.' + @controller_name + '.' + key, opts)
    end
    # バリデーションエラーメッセージ生成
    def validation_msg(attr, msg, msg_option=Hash.new)
      attr_str = attr
      attr_str = view_text('item_names.' + attr.to_s) unless String === attr
      option = {:attribute=>attr_str}
      option[:message] = I18n.t('errors.messages.' + msg.to_s, msg_option)
      return I18n.t('errors.format', option)
    rescue StandardError => ex
      return 'message generation error!!!'
    end
    # データモデルメッセージ生成
    def record_errors(record)
      msg_hash = Hash.new
      record.errors.each do |attr, msg|
        option = {:attribute=>record.class.human_attribute_name(attr), :message=>msg}
        msg_hash[attr] = I18n.t('errors.format', option)
      end
      return msg_hash
    end
    # 日時取得
    def date_time_param(item_name)
      date_time_hash = @params[item_name]
      year   = date_time_hash[:year]
      month  = date_time_hash[:month]
      day    = date_time_hash[:day]
      hour   = date_time_hash[:hour]
      minute = date_time_hash[:minute]
      second = date_time_hash[:second]
      hour   = '0' if blank?(hour)
      minute = '0' if blank?(minute)
      second = '0' if blank?(second)
      offset = DateTime.now.offset
      return DateTime.new(year.to_i, month.to_i, day.to_i, hour.to_i, minute.to_i, second.to_i, offset)
    rescue StandardError => ex
      return nil
    end
  end
end