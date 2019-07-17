# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：会員情報の誤登録データ削除アクション
# コントローラー：Registration::RegistrationController
# アクション：miss
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/12/08 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/registration/auth_base_action'
require 'data_cache/data_updated_cache'
require 'data_cache/member_state_cache'

module BizActions
  module Registration
    class MissAction < BizActions::Registration::AuthBaseAction
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
      def delete?
        # トランザクション処理
        ActiveRecord::Base.transaction do
          # アカウントキャッシュ更新
          @account_cache.data_update?
          return false unless valid?
          # 論理削除（アカウント）
          @account.delete_flg = true
          @account.save!
          # ペルソナ更新
          persona = @account.persona[0]
          persona.set_enc_value(:enc_mobile_id_no, @mobile_id_no)
          persona.set_enc_value(:enc_mobile_host, @mobile_host)
          persona.save!
          # データ更新日時の更新
          upd_cache = DataUpdatedCache.instance
          upd_cache.data_update?(:account, @account.updated_at, true)
          upd_cache.data_update?(:persona, persona.updated_at, true)
        end
        return true
      end
    end
  end
end