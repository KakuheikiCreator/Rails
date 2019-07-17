# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：受信したリクエスト情報をラッピングし、検証と規制クッキー情報の登録を行う
# コントローラー：RegulationCookie::RegulationCookieController
# アクション：create
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/03/25 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/regulation_cookie_list/base_action'

module BizActions
  module RegulationCookieList
    class CreateAction < BizActions::RegulationCookieList::BaseAction
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
      # 規制クッキー情報登録
      def save_data?
        save_flg = false
        ActiveRecord::Base.transaction do
          save_flg = @reg_cookie.save if valid?
        end
        # リスト検索
        @reg_cookie_list = default_search
        return save_flg
      end
      #########################################################################
      # protected定義
      #########################################################################
      protected
      # 単項目チェック
      def single_item_chk?
        # 入力項目の属性チェック
        check_result = @reg_cookie.valid?
        # モデルのバリデーションチェック
        unless check_result then
          @error_msg_hash.update(record_errors(@reg_cookie))
          unless @error_msg_hash[:system_id].nil? then
            @error_msg_hash[:system_id] = validation_msg(:system_name, :invalid)
          end
        end
        # その他条件チェック
        check_result = false unless cond_attr_chk?
        return check_result
      end
      
      # DB関連チェック
      def db_related_chk?
        # システム情報の有無判定
        check_result = system_exist_chk?
        # 重複データの有無判定
        if RegulationCookie.duplicate(@reg_cookie).size > 0 then
          @error_msg_hash[:error_msg] = view_text('sentences.duplicate_data')
          check_result = false
        end
        return check_result
      end
    end
  end
end