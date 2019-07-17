# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：全文検索フォーム基底アクションクラス
# コントローラー：Search::FulltextController
# アクション：
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/02/10 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/business_action'
require 'biz_search/quote_search'

module BizActions
  module SearchFulltext
    class BaseAction < BizActions::BusinessAction
      include BizSearch
      # リーダー
      attr_reader :login_flg, :quote, :comment, :result_list
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
        # 引用情報
        #######################################################################
        # 引用文
        @quote   = @params[:quote]
        # コメント
        @comment = @params[:comment]
        
        #######################################################################
        # 検索結果
        #######################################################################
        @result_list = Array.new
      end
      
      #########################################################################
      # protected定義
      #########################################################################
      protected
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