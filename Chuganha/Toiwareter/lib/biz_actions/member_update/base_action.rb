# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：会員情報更新基底アクションクラス
# コントローラー：Member::UpdateController
# アクション：form, confirm, update
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/01/21 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/business_action'
require 'data_cache/member_cache'
require 'data_cache/member_state_cache'
require 'data_cache/authority_cache'

module BizActions
  module MemberUpdate
    class BaseAction < BizActions::BusinessAction
      include DataCache
      # リーダー
      attr_reader :member_id, :member, :upd_member, :member_state_list, :authority_list
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        #######################################################################
        # マスタキャッシュデータ
        #######################################################################
        @member_state_list   = MemberStateCache.instance.member_state_list
        @authority_list  = AuthorityCache.instance.authority_list
        #######################################################################
        # OpenID
        #######################################################################
        @member_id = @function_state[:member_id]
        if admin? then
          @member_id ||= @params[:member_id]
          @member_id ||= @session[:member_id]
        else
          @member_id = @session[:member_id]
        end
        @function_state[:member_id] = @member_id
        #######################################################################
        # 項目値（更新前）
        #######################################################################
        @member = MemberCache.instance[@member_id]
        #######################################################################
        # 項目値（更新後）
        #######################################################################
        @upd_member = @member.dup
      end
      
      #########################################################################
      # public定義
      #########################################################################
      public
      # 管理者判定
      def admin?
        return Authority::AUTHORITY_CLS_ADMIN == @session[:authority_cls]
      end
      
      #########################################################################
      # protected定義
      #########################################################################
      protected
      # データモデルへのパラメータ設定
      def set_params(member)
        member.set_enc_value(:enc_nickname, @params[:nickname])
        if admin? then
          member.member_state_id = @params[:member_state_id]
          member.authority_id    = @params[:authority_id]
          member.set_enc_value(:enc_email, @params[:enc_email])
          member.join_date       = date_time_param(:join_date)
          member.last_login_date = date_time_param(:last_login_date)
          member.quote_cnt       = @params[:quote_cnt]
          member.quote_failure_cnt = @params[:quote_failure_cnt]
          member.quote_correct_cnt = @params[:quote_correct_cnt]
          member.quote_correct_failure_cnt = @params[:quote_correct_failure_cnt]
          member.comment_cnt     = @params[:comment_cnt]
          member.comment_failure_cnt = @params[:comment_failure_cnt]
          member.comment_report_cnt  = @params[:comment_report_cnt]
          member.were_reported_cnt   = @params[:were_reported_cnt]
          member.support_report_cnt  = @params[:support_report_cnt]
        end
        return member
      end
      
      # DB関連チェック（会員）
      def member_db_chk?
        # ユーザー情報の有無判定
        if MemberCache.instance[@upd_member.member_id].nil? then
          @error_msg_hash[:open_id] = error_msg('open_id', :inclusion)
          return false
        end
        return true
      end
      
      # DB関連チェック（会員状態）
      def member_state_db_chk?
        # 会員状態チェック
        if @upd_member.member_state.nil? then
          @error_msg_hash[:upd_member_state_id] = error_msg('member_state_id', :invalid)
          return false
        end
        return true
      end
      
      # DB関連チェック（権限）
      def authority_db_chk?
        # 権限チェック
        if @upd_member.authority.nil? then
          @error_msg_hash[:upd_authority_id] = error_msg('authority_id', :invalid)
          return false
        end
        return true
      end
      
      # エラーメッセージ処理
      def error_msg(attr_str, msg, msg_option=Hash.new)
        attr_name = view_text('form.item_names.' + attr_str)
        return validation_msg(attr_name, msg, msg_option)
      end
    end
  end
end