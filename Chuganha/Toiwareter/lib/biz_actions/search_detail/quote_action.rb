# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：引用詳細検索アクションクラス
# コントローラー：Quote::DetailController
# アクション：quote
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/03/09 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/search_detail/base_action'
require 'biz_search/quote_search'

module BizActions
  module SearchDetail
    class QuoteAction < BizActions::SearchDetail::BaseAction
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
        # 引用文
        cond_params[:quote] = @quote unless blank?(@quote)
        # 発言者
        cond_params[:speaker] = @speaker unless blank?(@speaker)
        # 発言者肩書き
        unless blank?(@speaker_job_title_id) then
          cond_params[:speaker_job_title_id] = @speaker_job_title_id
        end
        unless blank?(@speaker_job_title) then
          cond_params[:speaker_job_title] = @speaker_job_title
        end
        # 説明書
        cond_params[:description] = @description unless blank?(@description)
        # 投稿者
        unless blank?(@registered_member) then
          cond_params[:registered_member_id] = to_member_id(@registered_member)
        end
        # 訂正者
        unless blank?(@update_member) then
          cond_params[:update_member_id] = to_member_id(@update_member)
        end
        # 投稿日時
        unless blank?(@registered_date) then
          cond_params[:registered_date] = @registered_date
          cond_params[:registered_date_comp] = @registered_date_comp
        end
        # 検索処理
        @result_list = QuoteSearch.instance.detail(cond_params)
      end
      
      #########################################################################
      # protected定義
      #########################################################################
      protected
      # 単項目チェック
      def single_item_chk?
        # 引用項目チェック
        check_result = true
        # 引用文
        unless blank?(@quote) then
          if overflow?(@quote, 400) then
            @error_msg_hash[:quote] = error_msg('quote', :too_long, {:count=>400})
            check_result = false
          end
        end
        # 発言者
        unless blank?(@speaker) then
          if overflow?(@speaker, 60) then
            @error_msg_hash[:speaker] = error_msg('speaker', :too_long, {:count=>60})
            check_result = false
          end
        end
        # 発言者肩書きID
        unless blank?(@speaker_job_title_id) then
          if !numeric?(@speaker_job_title_id) then
            @error_msg_hash[:speaker_job_title] = error_msg('speaker_title', :invalid)
            check_result = false
          end
        end
        # 発言者肩書き
        unless blank?(@speaker_job_title) then
          if overflow?(@speaker_job_title, 40) then
            @error_msg_hash[:speaker_job_title] = error_msg('speaker_title', :too_long, {:count=>40})
            check_result = false
          end
        end
        # 引用文説明
        unless blank?(@description) then
          if overflow?(@description, 2000) then
            @error_msg_hash[:description] = error_msg('description', :too_long, {:count=>2000})
            check_result = false
          end
        end
        # 投稿者
        unless blank?(@registered_member) then
          if overflow?(@registered_member, 60) then
            @error_msg_hash[:registered_member] = error_msg('registered_member', :too_long, {:count=>60})
            check_result = false
          end
        end
        # 訂正者
        unless blank?(@update_member) then
          if overflow?(@update_member, 60) then
            @error_msg_hash[:update_member] = error_msg('update_member', :too_long, {:count=>60})
            check_result = false
          end
        end
        # 投稿日時
        unless blank?(@registered_date_comp) then
          unless valid_comp?(@registered_date_comp) then
            @error_msg_hash[:registered_date] = error_msg('registered_date', :invalid)
            check_result = false
          end
        end
        return check_result
      end
      
      # 項目関連チェック
      def related_items_chk?
        check_result = true
        # 抽出条件未入力チェック
        return check_result unless blank?(@quote)
        return check_result unless blank?(@speaker)
        return check_result unless blank?(@speaker_job_title_id)
        return check_result unless blank?(@speaker_job_title)
        return check_result unless blank?(@description)
        return check_result unless blank?(@registered_member)
        return check_result unless blank?(@update_member)
        return check_result unless blank?(@registered_date)
        # エラーメッセージ
        @error_msg_hash[:quote]             = error_msg('result_cond', :empty)
        @error_msg_hash[:speaker]           = error_msg('result_cond', :empty)
        @error_msg_hash[:speaker_job_title] = error_msg('result_cond', :empty)
        @error_msg_hash[:description]       = error_msg('result_cond', :empty)
        @error_msg_hash[:registered_member] = error_msg('result_cond', :empty)
        @error_msg_hash[:update_member]     = error_msg('result_cond', :empty)
        @error_msg_hash[:registered_date]   = error_msg('result_cond', :empty)
        check_result = false
        return check_result
      end
      
      # 引用DB関連チェック
      def db_related_chk?
        check_result = true
        # 肩書き
        if !blank?(@speaker_job_title_id) && !valid_job_id?(@speaker_job_title_id) then
          @error_msg_hash[:speaker_job_title] = error_msg('speaker_title', :invalid)
          check_result = false
        end
        return check_result
      end
    end
  end
end