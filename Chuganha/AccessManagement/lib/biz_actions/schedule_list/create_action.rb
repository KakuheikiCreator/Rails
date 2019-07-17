# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：受信したリクエスト情報をラッピングし、検証と解析情報取得設定の登録を行う
# コントローラー：ScheduleList::ScheduleListController
# アクション：create
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/08/10 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/schedule_list/base_action'

module BizActions
  module ScheduleList
    class CreateAction < BizActions::ScheduleList::BaseAction
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        # 現在日時
        @now_time = Time.now
        # 登録対象データ
        @from_schedule = RequestAnalysisSchedule.new
        @from_schedule.system_id = @system_id
        @from_schedule.gets_start_date = @from_datetime
        @to_schedule = RequestAnalysisSchedule.new
        @to_schedule.system_id = @system_id
        @to_schedule.gets_start_date = @to_datetime
      end
      
      #########################################################################
      # public定義
      #########################################################################
      public
      # 規制クッキー情報登録
      def save_data?
        save_flg = false
        ActiveRecord::Base.transaction do
          if valid? then
            save_flg = @from_schedule.save
            save_flg = @to_schedule.save if save_flg && !@to_datetime.nil?
          end
        end
        # リスト検索
        @schedule_list = default_search
        return save_flg
      end
      #########################################################################
      # protected定義
      #########################################################################
      protected
      # 単項目チェック
      def single_item_chk?
        # システムIDチェック
        check_result = items_attr_chk?
        if blank?(@system_id) then
          @error_msg_hash[:system_id] = validation_msg(:system_name, :invalid)
          check_result = false
        end
        # 取得開始日時のバリデーションチェック
        if @from_datetime.nil? then
          @error_msg_hash[:gets_start_date] = validation_msg(:gets_start_date, :blank)
          check_result = false
        end
        # その他条件チェック
        check_result = false unless cond_attr_chk?
        return check_result
      end
      
      # 項目関連チェック
      def related_items_chk?
        check_result = date_related_chk?
        # 現在日時との関連性チェック
        if @from_datetime <= @now_time then
          @error_msg_hash[:gets_start_date] = validation_msg(:gets_start_date, :invalid)
          check_result = false
        end
        return check_result
      end
      
      # DB関連チェック
      def db_related_chk?
        # システム情報の有無判定
        check_result = system_exist_chk?
        # 重複データの有無判定（From）
        if RequestAnalysisSchedule.duplicate(@from_schedule).size > 0 then
          @error_msg_hash[:error_msg] = view_text('sentences.duplicate_data')
          check_result = false
        end
        # 重複データの有無判定（To）
        if !@to_datetime.nil? && RequestAnalysisSchedule.duplicate(@to_schedule).size > 0 then
          @error_msg_hash[:error_msg] = view_text('sentences.duplicate_data')
          check_result = false
        end
        return check_result
      end
    end
  end
end