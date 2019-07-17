# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：会員情報の本登録アクション
# コントローラー：Registration::RegistrationController
# アクション：step_7
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/12/01 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/registration/auth_base_action'
require 'data_cache/data_updated_cache'
require 'data_cache/member_state_cache'

module BizActions
  module Registration
    class Step7Action < BizActions::Registration::AuthBaseAction
      include DataCache
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
      # 本登録処理
      def registration?
        # トランザクション処理
        ActiveRecord::Base.transaction do
          # アカウントキャッシュ更新
          @account_cache.data_update?
          return false unless valid?
          # アカウント本登録
          state_ent = MemberStateCache.instance[MemberState::MEMBER_STATE_CLS_DEFINITIVE]
          @account.member_state_id = state_ent.id
          @account.hsh_temp_password = nil
          @account.save!
          # ペルソナ更新
          persona = @account.persona[0]
          persona.set_enc_value(:enc_mobile_id_no, @mobile_id_no)
          persona.set_enc_value(:enc_mobile_host, @mobile_host)
          persona.save!
          # データ更新日時の更新
          upd_cache = DataUpdatedCache.instance
          upd_cache.next_version(:account)
          upd_cache.next_version(:persona)
        end
        return true
      end
    end
  end
end