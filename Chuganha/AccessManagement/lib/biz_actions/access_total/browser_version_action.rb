# -*- coding: utf-8 -*-
###############################################################################
# ブラウザIDに対応したブラウザバージョン情報を生成する
# 概要：受信したリクエスト情報をラッピングし、ブラウザバージョンテーブルの情報を生成する
# コントローラー：AccessTotal::AccessTotalController
# アクション：browser_version
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/10/01 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/business_action'

module BizActions
  module AccessTotal
    class BrowserVersionAction < BizActions::BusinessAction
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        # 抽出条件
        @browser_id = @params[:browser_id]
        @browser_version_list = nil
      end
      #########################################################################
      # public定義
      #########################################################################
      public
      # オプション生成処理
      def options_string
        option_list = [option('', view_text('sentences.all'))]
        if valid? then
          @browser_version_list.each do |ent|
            option_list.push(option(ent.id, ent.browser_version))
          end
        end
        return option_list.join
      end
      
      #########################################################################
      # protected定義
      #########################################################################
      protected
      # 単項目チェック
      def single_item_chk?
        # ブラウザID
        return false if blank?(@browser_id)
        return numeric?(@browser_id)
      end
      
      # DB関連チェック
      def db_related_chk?
        # システムデータ存在チェック
        @browser_version_list = BrowserVersion.where(:browser_id=>@browser_id.to_i)
        return !@browser_version_list.empty?
      end
      
      # option生成
      def option(val, name)
        return '<option value="' + val.to_s + '">' + name.to_s + '</option>'
      end
    end
  end
end