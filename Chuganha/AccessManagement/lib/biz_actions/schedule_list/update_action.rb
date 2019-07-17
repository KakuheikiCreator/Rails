# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：受信したリクエスト情報をラッピングし、検証と解析情報取得設定の登録を行う
# コントローラー：ScheduleList::ScheduleListController
# アクション：update
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/08/13 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/schedule_list/base_action'

module BizActions
  module ScheduleList
    class UpdateAction < BizActions::ScheduleList::BaseAction
      # アクセサー定義
      attr_reader :target_id, :analysis_schedule
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        # 現在日時
        @now_time = Time.now
        # 更新対象データ
        @target_id = nil
        @analysis_schedule = nil
      end
      
      #########################################################################
      # public定義
      #########################################################################
      public
      # 解析情報取得設定更新
      def update_data?
        # データの更新処理
        save_flg = false
        if valid? then
          ActiveRecord::Base.transaction do
            @analysis_schedule.update_attributes!(params[:analysis_schedule])
            save_flg = @analysis_schedule.save
          end
        end
        @error_msg_hash.update(record_errors(@analysis_schedule)) unless @analysis_schedule.nil?
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
        # ID項目の有無判定
        @target_id = params[:target_id]
        if blank?(@target_id) || !numeric?(@target_id) then
          @error_msg_hash[:error_msg] = validation_msg(:target_id, :invalid)
          return false
        end
        # モデルのバリデーションチェック
        @analysis_schedule = temp_model
        if @analysis_schedule.nil? then
          @error_msg_hash[:error_msg] = validation_msg(:target_data, :invalid)
          return false
        end
        unless @analysis_schedule.valid? then
          @error_msg_hash.update(record_errors(@analysis_schedule))
          @error_msg_hash[:error_msg] = validation_msg(:target_data, :invalid)
          return false
        end
        return true
      end
      
      # DB関連チェック
      def db_related_chk?
        # 更新データの有無判定
        @analysis_schedule = RequestAnalysisSchedule.where(:id=>@target_id.to_i)[0]
        if @analysis_schedule.nil? then
          @error_msg_hash[:error_msg] = validation_msg(:target_data, :not_found)
          return false
        end
        if @analysis_schedule.gets_start_date <= @now_time then
          @error_msg_hash[:error_msg] = validation_msg(:target_id, :invalid)
          return false
        end
        return true
      end
      
      # 一時データモデルの生成処理
      def temp_model
        analysis_schedule = RequestAnalysisSchedule.new(params[:analysis_schedule])
        analysis_schedule.system_id = 1 # ダミーデータ
        analysis_schedule.gets_start_date = Time.now # ダミーデータ
        return analysis_schedule
      rescue StandardError
        return nil
      end
    end
  end
end