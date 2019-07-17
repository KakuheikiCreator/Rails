# -*- coding: utf-8 -*-
###############################################################################
# システムIDに対応した機能情報を生成する
# 概要：受信したリクエスト情報をラッピングし、機能テーブルの情報を生成する
# コントローラー：AccessTotal::AccessTotalController
# アクション：function
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/10/01 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/business_action'

module BizActions
  module AccessTotal
    class FunctionAction < BizActions::BusinessAction
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        # 抽出条件
        @system_id = @params[:system_id]
        @function_list = nil
      end
      #########################################################################
      # public定義
      #########################################################################
      public
      # オプション生成処理
      def options_string
        option_list = [option('', view_text('sentences.all'))]
        if valid? then
          @function_list.each do |function|
            option_list.push(option(function.id, function.function_name))
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
        # システムID
        return false if blank?(@system_id)
        return numeric?(@system_id)
      end
      
      # DB関連チェック
      def db_related_chk?
        # システムデータ存在チェック
        @function_list = Function.where(:system_id=>@system_id.to_i)
        return !@function_list.empty?
      end
      
      # option生成
      def option(val, name)
        return '<option value="' + val.to_s + '">' + name.to_s + '</option>'
      end
    end
  end
end