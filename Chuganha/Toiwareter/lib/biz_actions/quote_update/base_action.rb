# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：引用更新フォーム基底アクションクラス
# コントローラー：Quote::UpdateController
# アクション：
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/02/25 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/business_action'
require 'biz_actions/quote_source/source_factory'
require 'biz_search/quote_search'
require 'data_cache/job_title_cache'

module BizActions
  module QuoteUpdate
    class BaseAction < BizActions::BusinessAction
      include BizActions::QuoteSource
      include BizSearch
      include DataCache
      # 結果ステータス
      STATUS_OK              = 0
      STATUS_AUTH_ERROR      = 1
      STATUS_QUOTE_NOT_FOUND = 2
      STATUS_QUOTE_ERROR     = 3
      # リーダー
      attr_reader :status, :quote_id, :quote_ent, :source_obj,
                  :quote, :speaker, :job_title_id, :job_title, :description
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        # 結果ステータス
        @status = nil
        # メッセージフォーム名
        @form_name = nil
        #######################################################################
        # 引用情報
        #######################################################################
        # 引用ID
        @quote_id  = @params[:quote_id]
        # 引用データ
        @quote_ent = nil
        # 引用文
        @quote   = @params[:quote]
        # 発言者
        @speaker = @params[:speaker]
        # 発言者肩書きID
        @job_title_id = @params[:job_title_id]
        # 発言者肩書き
        @job_title = @params[:job_title]
        # 引用文説明
        @description = @params[:description]
        
        #######################################################################
        # 出所情報
        #######################################################################
        # 出所情報アクション
        @source_obj = nil
        
        #######################################################################
        # 初期処理
        #######################################################################
        initialization
      end
      
      #########################################################################
      # public定義
      #########################################################################
      public
      # 受信情報チェック
      def valid?
        # 結果ステータス
        @valid_flg = super()
        @status ||= STATUS_OK
        return @valid_flg
      end
      
      #########################################################################
      # protected定義
      #########################################################################
      protected
      # 初期処理
      def initialization
        return if blank?(@quote_id)
        return unless numeric?(@quote_id.to_s)
        @quote_ent = Quote.find(@quote_id.to_i)
        return if @quote_ent.nil?
        @source_obj = SourceFactory.instance.create_action(@controller, @quote_ent.source_id)
      end
      
      # 対象の単項目チェック
      def target_item_chk?
        check_result = true
        # 引用ID
        if blank?(@quote_id) then
          @status ||= STATUS_QUOTE_NOT_FOUND
          check_result = false
        elsif !numeric?(@quote_id.to_s) then
          @status ||= STATUS_QUOTE_NOT_FOUND
          check_result = false
        end
        return check_result
      end
      
      # 単項目チェック（引用情報） 
      def quote_item_chk?
        check_result = true
        # 引用文
        if blank?(@quote) then
          @status ||= STATUS_QUOTE_ERROR
          @error_msg_hash[:quote] = error_msg('quote', :blank)
          check_result = false
        elsif overflow?(@quote, 200) then
          @status ||= STATUS_QUOTE_ERROR
          @error_msg_hash[:quote] = error_msg('quote', :too_long, {:count=>200})
          check_result = false
        end
        # 発言者
        if blank?(@speaker) then
          @status ||= STATUS_QUOTE_ERROR
          @error_msg_hash[:speaker] = error_msg('speaker', :blank)
          check_result = false
        elsif overflow?(@speaker, 60) then
          @status ||= STATUS_QUOTE_ERROR
          @error_msg_hash[:speaker] = error_msg('speaker', :too_long, {:count=>60})
          check_result = false
        end
        # 発言者肩書きID
        if !blank?(@job_title_id) && !numeric?(@job_title_id) then
          @status ||= STATUS_QUOTE_ERROR
          @error_msg_hash[:job_title] = error_msg('job_title', :invalid)
          check_result = false
        end
        # 発言者肩書き
        if overflow?(@job_title, 40) then
          @status ||= STATUS_QUOTE_ERROR
          @error_msg_hash[:job_title] = error_msg('job_title', :too_long, {:count=>40})
          check_result = false
        end
        # 引用文説明
        if overflow?(@description, 2000) then
          @status ||= STATUS_QUOTE_ERROR
          @error_msg_hash[:description] = error_msg('description', :too_long, {:count=>2000})
          check_result = false
        end
        return check_result
      end
      
      # 対象のDB関連チェック
      def target_db_related_chk?
        check_result = true
        # 引用
        if blank?(@quote_ent) then
          @status ||= STATUS_QUOTE_NOT_FOUND
          check_result = false
        elsif !valid_auth?(@quote_ent) then
          @status ||= STATUS_AUTH_ERROR
          check_result = false
        end
        return check_result
      end
      
      # 権限チェック
      def valid_auth?(quote_ent)
        return true if @session[:authority_hash][:quote_update]
        return true if @session[:member_id] == quote_ent.registered_member_id
        return @session[:member_id] == quote_ent.update_member_id
      end
      
      # 引用DB関連チェック
      def quote_db_related_chk?
        check_result = true
        # 項目更新チェック
        unless update_value? then
          @status ||= STATUS_QUOTE_ERROR
          @error_msg_hash[:quote] = view_text(@form_name.to_s + '.messages.not_updated_err')
          check_result = false
        end
        # 重複データ検索
        duplicate_list = QuoteSearch.instance.duplicate(@quote, @speaker)
        duplicate_list.delete_if do |ent| ent.id == @quote_ent.id end
        if duplicate_list.length > 0 then
          @status ||= STATUS_QUOTE_ERROR
          @error_msg_hash[:quote] = view_text(@form_name.to_s + '.messages.duplication_err')
          check_result = false
        end
        # 肩書き
        if !blank?(@job_title_id) && !JobTitleCache.instance.exist?(@job_title_id.to_i) then
          @status ||= STATUS_QUOTE_ERROR
          @error_msg_hash[:job_title] = error_msg('job_title', :invalid)
          check_result = false
        end
        return check_result
      end
      
      # 更新値チェック
      def update_value?
        # 引用文
        return true if @quote_ent.quote != @quote
        # 発言者
        return true if @quote_ent.speaker != @speaker
        # 発言者肩書きID
        return true if @quote_ent.speaker_job_title_id != @job_title_id.to_i
        # 発言者肩書き
        return true if @quote_ent.speaker_job_title != @job_title
        # 引用文説明
        return true if @quote_ent.description != @description
        # 出所更新チェック
        return @source_obj.edit_ent(@quote_ent.source).changed?
      end
      
      # エラーメッセージ処理
      def error_msg(attr_str, msg, msg_option=Hash.new)
        attr_name = view_text(@form_name.to_s + '.item_names.' + attr_str)
        return validation_msg(attr_name, msg, msg_option)
      end
    end
  end
end