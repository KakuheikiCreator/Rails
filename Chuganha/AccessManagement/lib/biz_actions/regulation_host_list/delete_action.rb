# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：受信したリクエスト情報をラッピングし、検証と規制ホスト情報の削除を行う
# コントローラー：RegulationHost::RegulationHostController
# アクション：delete
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/07/31 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/regulation_host_list/base_action'

module BizActions
  module RegulationHostList
    class DeleteAction < BizActions::RegulationHostList::BaseAction
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        @delete_id = params[:delete_id]
        @delete_data = nil
      end
      #########################################################################
      # public定義
      #########################################################################
      public
      # 規制クッキー情報削除
      def delete_data?
        delete_flg = false
        ActiveRecord::Base.transaction do
          delete_flg = valid?
          if delete_flg then
            @delete_data.destroy
          end
        end
        # 一覧検索
        @reg_host_list = default_search
        return delete_flg
      end
      #########################################################################
      # protected定義
      #########################################################################
      protected
      # 単項目チェック
      def single_item_chk?
        check_result = true
        # バリデーションチェック
        if @delete_id.nil? || !numeric?(@delete_id.to_s) then
          @error_msg_hash[:error_msg] = validation_msg(:target_data, :not_found)
          check_result = false
        end
        return check_result
      end
      # DB関連チェック
      def db_related_chk?
        check_result = true
        # データの有無判定
        RegulationHost.exists?(:id=>@delete_id.to_i)
        @delete_data = RegulationHost.where(:id=>@delete_id.to_i)[0]
        if @delete_data.nil? then
          @error_msg_hash[:error_msg] = validation_msg(:target_data, :not_found)
          check_result = false
        end
        return check_result
      end
    end
  end
end