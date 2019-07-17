# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：出所基底アクションクラス
# コントローラー：Quote::
# アクション：
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/02/25 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/business_action'
require 'common/net_util_module'

module BizActions
  module QuoteSource
    class SourceBaseAction < BizActions::BusinessAction
      include Common::NetUtilModule
      # リーダー
      attr_reader :form_name
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        # フォーム名
        @form_name = nil
      end
      
      #########################################################################
      # public定義
      #########################################################################
      public
      # データモデル値設定（抽象メソッド）
      def set_ent_values(source_ent)
        raise "Called abstract method: set_ent_values"
      end
      
      # データモデル生成（抽象メソッド）
      def edit_ent(source_ent=nil)
        raise "Called abstract method: edit_ent"
      end
      
      #########################################################################
      # protected定義
      #########################################################################
      protected
      # 日時取得処理
      def date_time_param(item_name)
        date_time_hash = @params[item_name]
        year = date_time_hash[:year]
        year_key = (item_name.to_s + '_year').to_sym
        year = @params[year_key] if @params.key?(year_key)
        return nil if blank?(year)
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
      
      # 日付取得処理
      def date_param(item_name)
        date_time_hash = @params[item_name]
        year = date_time_hash[:year]
        year_key = (item_name.to_s + '_year').to_sym
        year = @params[year_key] if @params.key?(year_key)
        return nil if blank?(year)
        month  = date_time_hash[:month]
        day    = date_time_hash[:day]
        return Date.new(year.to_i, month.to_i, day.to_i)
      rescue StandardError => ex
        return nil
      end
      
      # エラーメッセージ処理
      def error_msg(attr_str, msg, msg_option=Hash.new)
        attr_name = I18n.t('views.partials.source_form.' + @form_name + '.item_names.' + attr_str)
        return validation_msg(attr_name, msg, msg_option)
      end
    end
  end
end