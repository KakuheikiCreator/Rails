# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：会員更新アクションクラス
# コントローラー：Member::UpdateController
# アクション：update
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/01/21 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/member_update/check_action'

module BizActions
  module MemberUpdate
    class UpdateAction < BizActions::MemberUpdate::BaseAction
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
      # 更新処理
      def update?
        ActiveRecord::Base.transaction do
          return false unless valid?
          # 会員データモデルの編集
          @upd_member = set_params(@member)
          member_state_cls = @upd_member.member_state.member_state_cls
          if MemberState::MEMBER_STATE_CLS_REGISTERED == member_state_cls then
            @upd_member.ineligibility_date = nil
          else
            @upd_member.ineligibility_date = Time.now
          end
          # 会員データモデルの更新
          @upd_member.save!
          # キャッシュデータ更新
          MemberCache.instance.refresh_data(@upd_member)
          # セッション情報の更新
          if @session[:open_id] ==  @upd_member.open_id then
            @session[:nickname] = @upd_member.nickname
            @session[:authority_cls] = @upd_member.authority.authority_cls
          end
        end
        return true
      end
    end
  end
end