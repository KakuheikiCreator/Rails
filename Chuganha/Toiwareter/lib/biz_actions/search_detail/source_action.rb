# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：引用詳細検索アクションクラス
# コントローラー：Quote::DetailController
# アクション：source
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/03/09 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/search_detail/base_action'
require 'biz_search/source_search'

module BizActions
  module SearchDetail
    class SourceAction < BizActions::SearchDetail::BaseAction
      include BizSearch
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
      end
      
      #########################################################################
      # public定義
      #########################################################################
      public
      # 検索処理
      def search?
        return false unless valid?
        # 検索条件
        cond_params = Hash.new
        # 出所ID
        cond_params[:source_id] = @source_id unless blank?(@source_id)
        # 媒体名
        cond_params[:media_name] = @media_name unless blank?(@media_name)
        # 媒体配信元
        cond_params[:media_source] = @media_source unless blank?(@media_source)
        # 配信日時
        unless blank?(@distribution_date) then
          cond_params[:distribution_date] = @distribution_date
          cond_params[:distribution_date_comp] = @distribution_date_comp
        end
        # 報じた人
        cond_params[:reporter] = @reporter unless blank?(@reporter)
        # 報じた人の肩書きID
        unless blank?(@reporter_job_title_id) then
          cond_params[:reporter_job_title_id] = @reporter_job_title_id
        end
        # 報じた人の肩書き
        unless blank?(@reporter_job_title) then
          cond_params[:reporter_job_title] = @reporter_job_title
        end
        # 検索処理
        @result_list = Array.new
        source_list = SourceSearch.instance.detail(cond_params)
        source_list.each do |source_ent|
          @result_list.push(source_ent.quote)
        end
      end
      
      #########################################################################
      # protected定義
      #########################################################################
      protected
      # 単項目チェック
      def single_item_chk?
        # 引用項目チェック
        check_result = true
        # 出所ID
        if blank?(@source_id) then
          @error_msg_hash[:source_id] = error_msg('source_class', :blank)
          check_result = false
        elsif !numeric?(@source_id) then
          @error_msg_hash[:source_id] = error_msg('source_class', :invalid)
          check_result = false
        end
        # 媒体名
        unless blank?(@media_name) then
          if overflow?(@media_name, 60) then
            @error_msg_hash[:media_name] = error_msg('media_name', :too_long, {:count=>60})
            check_result = false
          end
        end
        # 媒体配信元
        unless blank?(@media_source) then
          if overflow?(@media_source, 60) then
            @error_msg_hash[:media_source] = error_msg('media_source', :too_long, {:count=>60})
            check_result = false
          end
        end
        # 配信日時
        unless blank?(@distribution_date_comp) then
          unless valid_comp?(@distribution_date_comp) then
            @error_msg_hash[:distribution_date] = error_msg('delivery_date', :invalid)
            check_result = false
          end
        end
        # 報じた人
        unless blank?(@reporter) then
          if overflow?(@reporter, 60) then
            @error_msg_hash[:reporter] = error_msg('reporter', :too_long, {:count=>60})
            check_result = false
          end
        end
        # 報じた人の肩書きID
        unless blank?(@reporter_job_title_id) then
          if !numeric?(@reporter_job_title_id) then
            @error_msg_hash[:reporter_job_title] = error_msg('reporter_title', :invalid)
            check_result = false
          end
        end
        # 報じた人の肩書き
        unless blank?(@reporter_job_title) then
          if overflow?(@reporter_job_title, 40) then
            @error_msg_hash[:reporter_job_title] = error_msg('reporter_title', :too_long, {:count=>40})
            check_result = false
          end
        end
        return check_result
      end
      
      # 項目関連チェック
      def related_items_chk?
        check_result = true
        # 抽出条件未入力チェック
        return check_result unless blank?(@media_name)
        return check_result unless blank?(@media_source)
        return check_result unless blank?(@distribution_date)
        return check_result unless blank?(@reporter)
        return check_result unless blank?(@reporter_job_title_id)
        return check_result unless blank?(@reporter_job_title)
        # エラーメッセージ
        @error_msg_hash[:media_name]            = error_msg('result_cond', :empty)
        @error_msg_hash[:media_source]          = error_msg('result_cond', :empty)
        @error_msg_hash[:distribution_date]     = error_msg('result_cond', :empty)
        @error_msg_hash[:reporter]              = error_msg('result_cond', :empty)
        @error_msg_hash[:reporter_job_title]    = error_msg('result_cond', :empty)
        check_result = false
        return check_result
      end
      
      # 引用DB関連チェック
      def db_related_chk?
        check_result = true
        # 肩書き
        if !blank?(@reporter_job_title_id) && !valid_job_id?(@reporter_job_title_id) then
          @error_msg_hash[:reporter_job_title] = error_msg('reporter_job_title', :invalid)
          check_result = false
        end
        return check_result
      end
    end
  end
end