# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：会員更新チェックアクションクラス
# コントローラー：Member::UpdateController
# アクション：check
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/01/21 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/member_update/base_action'

module BizActions
  module MemberUpdate
    class CheckAction < BizActions::MemberUpdate::BaseAction
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        # 項目値更新
        set_params(@upd_member)
      end
      
      #########################################################################
      # protected定義
      #########################################################################
      protected
      # 単項目チェック
      def single_item_chk?
        # 更新項目チェック
        check_result = @upd_member.valid?
        @error_msg_hash.update(record_errors(@upd_member)) unless check_result
        return check_result
      end
      
      # DB関連チェック
      def db_related_chk?
        # DB関連チェック（会員）
        check_result = member_db_chk?
        # DB関連チェック（会員状態）
        check_result = false unless member_state_db_chk?
        # DB関連チェック（権限）
        check_result = false unless authority_db_chk?
        return check_result
      end
    end
  end
end