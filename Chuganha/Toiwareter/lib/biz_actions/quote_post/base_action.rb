# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：引用投稿フォーム基底アクションクラス
# コントローラー：Quote::PostController
# アクション：
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/01/23 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/business_action'
require 'biz_actions/quote_source/source_factory'
require 'biz_search/quote_search'
require 'data_cache/job_title_cache'
require 'data_cache/source_cache'

module BizActions
  module QuotePost
    class BaseAction < BizActions::BusinessAction
      include BizActions::QuoteSource
      include BizSearch
      include DataCache
      # リーダー
      attr_reader :quote, :speaker, :job_title_id, :job_title, :description, :comment,
                  :source_id, :source_obj
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        # 表示フォーム名
        @form_name = nil
        #######################################################################
        # 引用情報
        #######################################################################
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
        # コメント
        @comment = @params[:comment]
        
        #######################################################################
        # 出所情報
        #######################################################################
        # 出所ID
        @source_id = @params[:source_id]
        @source_id ||= '1'
        # 出所情報アクション
        @source_obj = SourceFactory.instance.create_action(@controller, @source_id)
      end
      
      #########################################################################
      # protected定義
      #########################################################################
      protected
      # 単項目チェック（引用情報） 
      def quote_item_chk?
        check_result = true
        # 引用文
        if blank?(@quote) then
          @error_msg_hash[:quote] = error_msg('quote', :blank)
          check_result = false
        elsif overflow?(@quote, 200) then
          @error_msg_hash[:quote] = error_msg('quote', :too_long, {:count=>200})
          check_result = false
        end
        # 発言者
        if blank?(@speaker) then
          @error_msg_hash[:speaker] = error_msg('speaker', :blank)
          check_result = false
        elsif overflow?(@speaker, 60) then
          @error_msg_hash[:speaker] = error_msg('speaker', :too_long, {:count=>60})
          check_result = false
        end
        # 発言者肩書きID
        if !blank?(@job_title_id) && !numeric?(@job_title_id) then
          @error_msg_hash[:job_title] = error_msg('job_title', :invalid)
          check_result = false
        end
        # 発言者肩書き
        if overflow?(@job_title, 40) then
          @error_msg_hash[:job_title] = error_msg('job_title', :too_long, {:count=>40})
          check_result = false
        end
        # 出所ID
        if blank?(@source_id) then
          @error_msg_hash[:source_id] = error_msg('source_class', :blank)
          check_result = false
        elsif !numeric?(@source_id) then
          @error_msg_hash[:source_id] = error_msg('source_class', :invalid)
          check_result = false
        end
        # 引用文説明
        if overflow?(@description, 2000) then
          @error_msg_hash[:description] = error_msg('description', :too_long, {:count=>2000})
          check_result = false
        end
        # コメント
        if blank?(@comment) then
          @error_msg_hash[:comment] = error_msg('comment', :blank)
          check_result = false
        elsif overflow?(@comment, 4000) then
          @error_msg_hash[:comment] = error_msg('comment', :too_long, {:count=>4000})
          check_result = false
        end
        return check_result
      end
      
      # 引用DB関連チェック
      def quote_db_related_chk?
        check_result = true
        # 重複データ検索
        if QuoteSearch.instance.duplicate(@quote, @speaker).length > 0 then
          @error_msg_hash[:quote] = view_text(@form_name.to_s + '.messages.duplication_err')
          check_result = false
        end
        # 肩書き
        if !blank?(@job_title_id) && !JobTitleCache.instance.exist?(@job_title_id.to_i) then
          @error_msg_hash[:job_title] = error_msg('job_title', :invalid)
          check_result = false
        end
        # 出所ID
        if !blank?(@source_id) && !SourceCache.instance.exist?(@source_id.to_i) then
          @error_msg_hash[:source_id] = error_msg('source_id', :invalid)
          check_result = false
        end
        return check_result
      end
      
      # エラーメッセージ処理
      def error_msg(attr_str, msg, msg_option=Hash.new)
        attr_name = view_text(@form_name.to_s + '.item_names.' + attr_str)
        return validation_msg(attr_name, msg, msg_option)
      end
    end
  end
end