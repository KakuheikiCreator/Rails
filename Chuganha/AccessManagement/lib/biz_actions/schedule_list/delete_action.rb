# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：受信したリクエスト情報をラッピングし、検証と規制ホスト情報の削除を行う
# コントローラー：ScheduleList::ScheduleListController
# アクション：delete
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/08/16 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/schedule_list/base_action'

module BizActions
  module ScheduleList
    class DeleteAction < BizActions::ScheduleList::BaseAction
      include DataCache
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        @delete_id = params[:delete_id]
        @delete_list = nil
      end
      #########################################################################
      # public定義
      #########################################################################
      public
      # 規制クッキー情報削除
      def delete_data?
        delete_flg = false
        ActiveRecord::Base.transaction do
          delete_flg = valid?
          if delete_flg then
            @delete_list.each do |delete_data|
              begin
                delete_data.destroy
              rescue => ex
                @logger.error('Exception:' + ex.class.name)
                @logger.error('Message  :' + ex.message)
                @logger.error('Backtrace:' + ex.backtrace)
              end
            end
          end
        end
        # リスト検索
        @schedule_list = default_search
        return delete_flg
      end
      #########################################################################
      # protected定義
      #########################################################################
      protected
      # 単項目チェック
      def single_item_chk?
        # 入力項目の属性チェック
        check_result = items_attr_chk?
        # その他条件チェック
        check_result = false unless cond_attr_chk?
        # 削除対象IDチェック
        if blank?(@delete_id) then
          if blank?(@from_datetime) && blank?(@to_datetime) then
            @error_msg_hash[:error_msg] = validation_msg(:target_data, :not_found)
            check_result = false
          end
        elsif !numeric?(@delete_id.to_s) then
          @error_msg_hash[:error_msg] = validation_msg(:target_data, :not_found)
          check_result = false
        end
        return check_result
      end
      
      # 項目関連チェック
      def related_items_chk?
        return date_related_chk?
      end
      
      # DB関連チェック
      def db_related_chk?
        check_result = true
        # データの有無判定
        if blank?(@delete_id) then
          cond_hash = {:system_id=>@system_id,
                       :from_datetime=>@from_datetime,
                       :to_datetime=>@to_datetime}
          @delete_list = RequestAnalysisSchedule.find_list(cond_hash)
        else
          @delete_list = RequestAnalysisSchedule.where(:id=>@delete_id.to_i)
        end
        if @delete_list.empty? then
          @error_msg_hash[:error_msg] = validation_msg(:target_data, :not_found)
          check_result = false
        end
        return check_result
      end
    end
  end
end