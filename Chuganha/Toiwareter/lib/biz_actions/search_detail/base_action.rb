# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：詳細検索フォーム基底アクションクラス
# コントローラー：Search::DetailController
# アクション：
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/03/03 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/business_action'
require 'biz_search/member_search'
require 'biz_search/quote_search'
require 'data_cache/generic_code_cache'
require 'data_cache/job_title_cache'

module BizActions
  module SearchDetail
    class BaseAction < BizActions::BusinessAction
      include BizSearch
      include DataCache
      # リーダー
      attr_reader :login_flg,
                  :quote, :speaker, :speaker_job_title_id, :speaker_job_title, :description,
                  :registered_member, :update_member, :registered_date, :registered_date_comp,
                  :source_id, :media_name, :media_source, :distribution_date, :distribution_date_comp,
                  :reporter, :reporter_job_title_id, :reporter_job_title,
                  :comment, :critic_member, :criticism_date, :criticism_date_comp,
                  :result_list
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        #######################################################################
        # ログイン状態
        #######################################################################
        @login_flg = login_user?
        
        #######################################################################
        # キャッシュデータ
        #######################################################################
        @generic_code_cache = GenericCodeCache.instance
        
        #######################################################################
        # 検索条件（引用）
        #######################################################################
        # 引用文
        @quote   = @params[:quote]
        # 発言者
        @speaker = @params[:speaker]
        # 発言者肩書き
        @speaker_job_title_id = @params[:speaker_job_title_id]
        @speaker_job_title    = @params[:speaker_job_title]
        # 説明書
        @description       = @params[:description]
        # 投稿者
        @registered_member = @params[:registered_member]
        # 訂正者
        @update_member     = @params[:update_member]
        # 投稿日時
        @registered_date        = date_time_param(:registered_date)
        @registered_date_comp   = @params[:registered_date_comp]
        
        #######################################################################
        # 検索条件（出典）
        #######################################################################
        # 出所ID
        @source_id    = @params[:source_id]
        # 媒体名
        @media_name   = @params[:media_name]
        # 媒体配信元
        @media_source = @params[:media_source]
        # 配信日時
        @distribution_date      = date_time_param(:distribution_date)
        @distribution_date_comp = @params[:distribution_date_comp]
        # 報じた人
        @reporter     = @params[:reporter]
        # 報じた人の肩書き
        @reporter_job_title_id  = @params[:reporter_job_title_id]
        @reporter_job_title     = @params[:reporter_job_title]
        
        #######################################################################
        # 検索条件（コメント）
        #######################################################################
        # コメント
        @comment = @params[:comment]
        # 批評者
        @critic_member = @params[:critic_member]
        # 批評日時
        @criticism_date      = date_time_param(:criticism_date)
        @criticism_date_comp = @params[:criticism_date_comp]
        
        #######################################################################
        # 検索結果
        #######################################################################
        @result_list = Array.new
      end
      
      #########################################################################
      # protected定義
      #########################################################################
      protected
      # 比較条件チェック
      def valid_comp?(comp_val)
        return @generic_code_cache.code_values(:COMP_COND_CLS).include?(comp_val)
      end
      
      # 肩書きIDチェック
      def valid_job_id?(job_title_id)
        return false if blank?(job_title_id)
        return JobTitleCache.instance.exist?(job_title_id.to_i)
      end
      
      # 会員ID抽出
      def to_member_id(member_str)
        member_id = member_str.slice(/^U\d{9}$/)
        return member_id unless member_id.nil?
        search = MemberSearch.instance.find_by_nickname(member_str, 1)
        return search.results[0].member_id if search.results.length > 0
        return nil
      end
      
      # ログイン済み判定
      def login_user?
        return false if @session[:member_id].nil?
        return true if @request.request_method == 'POST'
        return @request.flash[:redirect_flg] == true
      end
      
      # エラーメッセージ処理
      def error_msg(attr_str, msg, msg_option=Hash.new)
        attr_name = view_text('form.item_names.' + attr_str)
        return validation_msg(attr_name, msg, msg_option)
      end
    end
  end
end