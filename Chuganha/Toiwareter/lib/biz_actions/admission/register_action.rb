# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：新規会員登録アクションクラス
# コントローラー：Admission::AdmissionController
# アクション：register
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/01/09 Nakanohito
# 更新日:
###############################################################################
require 'common/session_util_module'
require 'common/net_util_module'
require 'biz_actions/business_action'
require 'biz_common/biz_numbering'
require 'data_cache/member_cache'

module BizActions
  module Admission
    class RegisterAction < BizActions::BusinessAction
      include Common::NetUtilModule
      include BizCommon
      include DataCache
      # リーダー
      attr_reader :open_id, :nickname, :email
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        # プロパティ
        @open_id   = @function_state[:open_id]
        @nickname  = @params[:nickname]
        @email     = @function_state[:email]
        @agreement = @params[:agreement]
      end
      
      #########################################################################
      # public定義
      #########################################################################
      public
      # 登録処理
      def registration?
        # トランザクション処理
        member_ent   = nil
        ActiveRecord::Base.transaction do
          return false unless valid?
          # 会員の登録
          member_ent = create_member_ent
          member_ent.save!
        end
        # セッション初期化
        Common::SessionUtilModule.function_state_init?(@controller)
        @controller.session[:member_id] = member_ent.member_id
        @controller.session[:authority_cls] = member_ent.authority.authority_cls
        @controller.session[:nickname]  = member_ent.nickname
        @controller.session[:authority_hash] = member_ent.authority_hash
        return true
      end
      
      #########################################################################
      # protected定義
      #########################################################################
      protected
      # 単項目チェック
      def single_item_chk?
        check_result = true
        # ニックネーム
        if blank?(@nickname) then
          @error_msg_hash[:nickname] = error_msg('nickname', :blank)
          check_result = false
        elsif overflow?(@nickname, 255) then
          @error_msg_hash[:nickname] = error_msg('nickname', :invalid)
          check_result = false
        end
        # メールアドレス
        if blank?(@email) then
#          @error_msg_hash[:email] = error_msg('email', :blank)
#          check_result = false
        elsif !valid_email?(@email) then
          @error_msg_hash[:email] = error_msg('email', :invalid)
          check_result = false
        end
        # 会員規約同意
        if @agreement != 'true' then
          @error_msg_hash[:agreement] = error_msg('agreement', :invalid)
          check_result = false
        end
        return check_result
      end
      
      # DB関連チェック
      def db_related_chk?
        check_result = true
        unless MemberCache.instance.open_id_rec(@open_id).nil? then
          @error_msg_hash[:open_id] = error_msg('open_id', :exclusion)
          check_result = false
        end
        return check_result
      end
      
      # 会員生成
      def create_member_ent
        next_num = BizNumbering.instance.next_number(:model_item, :member_id)
        member = Member.new
        member.set_enc_value(:enc_open_id, @open_id)
        member.member_id = 'U' + next_num.to_s.rjust(9, '0')
        member.member_state_cls(MemberState::MEMBER_STATE_CLS_REGISTERED)
        member.authority_cls(Authority::AUTHORITY_CLS_GENERAL)
        member.set_enc_value(:enc_nickname, @nickname)
        member.set_enc_value(:enc_email, @email)
        time_now = Time.zone.now
        member.join_date       = time_now
        member.last_login_date = time_now
        member.login_cnt = 1
        member.quote_cnt = 0
        member.quote_failure_cnt = 0
        member.quote_correct_cnt = 0
        member.quote_correct_failure_cnt = 0
        member.quote_delete_cnt  = 0
        member.comment_cnt       = 0
        member.comment_failure_cnt = 0
        member.comment_report_cnt  = 0
        member.were_reported_cnt   = 0
        member.support_report_cnt  = 0
        return member
      end
      
      # エラーメッセージ処理
      def error_msg(attr_str, msg, msg_option=Hash.new)
        attr_name = view_text('form.item_names.' + attr_str)
        return validation_msg(attr_name, msg, msg_option)
      end
    end
  end
end