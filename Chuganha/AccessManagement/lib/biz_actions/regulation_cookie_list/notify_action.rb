# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：受信したリクエスト情報をラッピングし、検証と規制クッキー情報の更新通知を行う
# コントローラー：RegulationCookie::RegulationCookieController
# アクション：notify
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/06/10 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/regulation_cookie_list/base_action'
require 'biz_common/biz_notify_list'
require 'data_cache/data_updated_date_cache'

module BizActions
  module RegulationCookieList
    class NotifyAction < BizActions::RegulationCookieList::BaseAction
      include BizCommon
      include DataCache
      #########################################################################
      # 定数定義
      #########################################################################
      PROCESS_ID = 'DUN002'
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        # リスト検索
        @reg_cookie_list = default_search
        # データ更新日時キャッシュ
        @cache = DataUpdatedDateCache.instance
        # 通知リスト
        @notify_list = BizNotifyList.instance
      end
      #########################################################################
      # public定義
      #########################################################################
      public
      # 規制クッキー情報更新通知
      def notify?
        notify_flg = false
        if valid? then
          # 更新日時更新
          if @cache.data_update?(:regulation_cookie, Time.now, true) then
            # キャッシュデータ更新通知
            notify_flg = @notify_list.notify_process?(PROCESS_ID)
          end
        end
        return notify_flg
      end
      
      #########################################################################
      # protected定義
      #########################################################################
      protected
      # 単項目チェック
      def single_item_chk?
        # 入力項目の属性チェック
        check_result = items_attr_chk?
        # その他条件チェック
        check_result = false unless cond_attr_chk?
        return check_result
      end
      # DB関連チェック
      def db_related_chk?
        # システム存在チェック
        return system_exist_chk?
      end
    end
  end
end