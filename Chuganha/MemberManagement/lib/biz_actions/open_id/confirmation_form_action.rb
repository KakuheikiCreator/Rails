# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：RPのログイン認証フォームを確認をする
# コントローラー：OpenID::OPController
# アクション：confirmation_form
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2013/01/02 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/open_id/base_action'
require 'biz_common/biz_document'

module BizActions
  module OpenId
    class ConfirmationFormAction < BizActions::OpenId::BaseAction
      include BizCommon
      # アクセサー定義
      attr_reader :trust_root, :open_id, :sreg_disp_hash, :terms_of_providing
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        @oidreq = @session[:last_oidreq]
        @trust_root = nil
        @open_id = nil
        @sreg_disp_hash = Hash.new
        @terms_of_providing = BizDocument.instance[:terms_of_providing]
      end
      
      #########################################################################
      # public定義
      #########################################################################
      public
      # 確認フォームデータ生成処理
      def form_action?
        return false unless valid?
        @trust_root = @oidreq.trust_root
        @open_id = url_for_user
        # RPからのリクエストフィールドハッシュ生成
        sregreq = @op_server.ex_sreg_request(@oidreq)
        @sreg_disp_hash = create_disp_hash(sregreq)
        return true
      end
      
      #########################################################################
      # protected定義
      #########################################################################
      protected
      # 単項目チェック
      def single_item_chk?
        check_result = true
        # ログインセッションチェック
        if blank?(@session[:user_id]) then
          check_result = false
        end
        # OpenIDリクエスト存在チェック
        if @oidreq.nil? then
          check_result = false
        end
        return check_result
      end
      
      # SREGのユーザー属性データ生成
      def create_disp_hash(sregreq)
        # ユーザーデータ
        account = AccountCache.instance.user_id_rec(@session[:user_id])
        persona = account.persona[0]
        user_data_hash = {
          'nickname'=>@session[:nickname],
          'fullname'=>account.fullname,
          'email'=>persona.dec_value(:enc_email),
          'dob'=>Time.parse(account.dec_value(:enc_birth_date)).strftime("%Y-%m-%d"),
          'gender'=>account.gender.gender,
          'postcode'=>persona.dec_value(:enc_postcode),
          'country'=>persona.country.country_name,
          'language'=>persona.language.lang_name,
          'timezone'=>persona.dec_value(:enc_timezone_id)
        }
        # 参照データ
        sreg_disp_hash = Hash.new
        sregreq.all_requested_fields.each do |field|
          sreg_disp_hash[field] = user_data_hash[field.to_s]
        end
        return sreg_disp_hash
      end
    end
  end
end