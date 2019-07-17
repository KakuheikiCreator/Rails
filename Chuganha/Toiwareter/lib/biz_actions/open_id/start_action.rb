# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：OpenIDのProviderにログイン認証依頼をする
# コントローラー：OpenID::RPController
# アクション：start
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2012/11/15 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/business_action'
require 'common/net_util_module'
require 'authentication/auth_consumer'
require 'data_cache/generic_code_cache'

module BizActions
  module OpenId
    class StartAction < BizActions::BusinessAction
      include Authentication
      include DataCache
      include Common::NetUtilModule
      # アクセサー定義
      attr_reader :open_id, :result_ptn, :oidreq, :realm, :return_to
      #########################################################################
      # 定数定義
      #########################################################################
      PTN_INVALID  = 0 # 入力データ不正
      PTN_REDIRECT = 1 # OPへリダイレクト
      PTN_POST_REDIRECT = 2 # OPエラー
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        @open_id = @params[:open_id]
        @result_ptn = PTN_INVALID
        @oidreq = nil
        @realm =nil
        @return_to = nil
      end
      
      #########################################################################
      # public定義
      #########################################################################
      public
      # OpenID認証開始処理
      def start
        unless valid? then
          @result_ptn = PTN_INVALID
          return
        end
        #　OpenIDリクエストの生成
        consumer = AuthConsumer.new(@session)
        begin
          @oidreq = consumer.request(@open_id)
        rescue OpenID::OpenIDError
          # OpenIDプロバイダが見つからない
          @error_msg_hash[:login_form] = view_text('index.sentences.err_msg_1')
          @result_ptn = PTN_INVALID
          return
        end
        # SREG情報設定
        req_fields = ['nickname', 'email']
        @oidreq.add_extension(consumer.sreg_request(req_fields))
        # RPのURL生成
        @realm = @controller.url_for(:action=>'index', :only_path=>false)
        # OPからのリダイレクト先URL生成
        @return_to = @controller.url_for(:action=>'complete', :only_path=>false)
        # OPへのリダイレクト判定
        if @oidreq.send_redirect?(@realm, @return_to) then
          # OPへリダイレクトして認証依頼
          @result_ptn = PTN_REDIRECT
        else
          # Javascriptを埋め込んだレスポンスを返して、OPへPOSTでリダイレクト
          @result_ptn = PTN_POST_REDIRECT
        end
      end
      
      #########################################################################
      # protected定義
      #########################################################################
      protected
      # 単項目チェック
      def single_item_chk?
        check_result = true
        # OpenID
#        unless valid_uri?(@open_id) then
#          @error_msg_hash[:login_form] = view_text('index.sentences.err_msg_4')
#          check_result = false
#        end
        return check_result
      end
      
      # DB関連チェック
      def db_related_chk?
        check_result = true
        # OpenID　Providerチェック
        valid_prefix_flg = false
        GenericCodeCache.instance.code_labels(:VALID_OP_PREFIX).each do |op_prefix|
          if @open_id.start_with?(op_prefix) then
            valid_prefix_flg = true
            break
          end
        end
        unless valid_prefix_flg then
          @error_msg_hash[:login_form] = view_text('index.sentences.err_msg_4')
          check_result = false
        end
        return check_result
      end
    end
  end
end