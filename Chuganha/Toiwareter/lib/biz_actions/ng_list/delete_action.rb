# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：NGワード削除アクションクラス
# コントローラー：NGList::NGListController
# アクション：delete
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/01/15 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/ng_list/base_action'
require 'data_cache/data_updated_cache'

module BizActions
  module NgList
    class DeleteAction < BizActions::NgList::BaseAction
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        @delete_id = @params[:delete_id]
      end
      
      #########################################################################
      # public定義
      #########################################################################
      public
      # 削除処理
      def delete?
        # トランザクション処理
        ActiveRecord::Base.transaction do
          return false unless valid?
          # NGワードの削除
          NgWord.delete(@delete_id.to_i)
          # バージョン情報更新
          DataUpdatedCache.instance.next_version(:ng_word)
          # NGワードリスト
          NgWordCache.instance.data_load
          @list = NgWordCache.instance.ng_word_list
        end
        return true
      end
      
      #########################################################################
      # protected定義
      #########################################################################
      protected
      # 単項目チェック
      def single_item_chk?
        check_result = true
        # 削除対象データID
        if blank?(@delete_id) then
          @error_msg_hash[:delete_id] = error_msg('delete_id', :blank)
          check_result = false
        elsif !numeric?(@delete_id) then
          @error_msg_hash[:delete_id] = error_msg('delete_id', :invalid)
          check_result = false
        end
        return check_result
      end
      
      # エラーメッセージ処理
      def error_msg(attr_str, msg, msg_option=Hash.new)
        attr_name = view_text('list.item_names.' + attr_str)
        return validation_msg(attr_name, msg, msg_option)
      end
    end
  end
end