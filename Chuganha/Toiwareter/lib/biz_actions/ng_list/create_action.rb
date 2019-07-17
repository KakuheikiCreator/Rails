# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：NGワード登録アクションクラス
# コントローラー：NGList::NGListController
# アクション：create
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/01/14 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/ng_list/base_action'
require 'data_cache/data_updated_cache'

module BizActions
  module NgList
    class CreateAction < BizActions::NgList::BaseAction
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
      # 登録処理
      def create?
        # トランザクション処理
        ActiveRecord::Base.transaction do
          # キャッシュリフレッシュ
          NgWordCache.instance.data_load
          return false unless valid?
          # NGワードの登録
          ng_word_ent.save!
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
        # NGワード
        if blank?(@ng_word) then
          @error_msg_hash[:ng_word] = error_msg('ng_word', :blank)
          check_result = false
        elsif overflow?(@ng_word, 255) then
          @error_msg_hash[:ng_word] = error_msg('ng_word', :invalid)
          check_result = false
        end
        # 置換文字列
        if blank?(@replace_word) then
          @error_msg_hash[:replace_word] = error_msg('replace_word', :blank)
          check_result = false
        elsif overflow?(@replace_word, 255) then
          @error_msg_hash[:replace_word] = error_msg('replace_word', :invalid)
          check_result = false
        end
        return check_result
      end
      
      # DB関連チェック
      def db_related_chk?
        check_result = true
        if NgWordCache.instance.exist?(@ng_word) then
          @error_msg_hash[:ng_word] = error_msg('ng_word', :exclusion)
          check_result = false
        end
        return check_result
      end
      
      # 会員生成
      def ng_word_ent
        ng_word_ent = NgWord.new
        ng_word_ent.ng_word = @ng_word
        ng_word_ent.replace_word = @replace_word
        ng_word_ent.replace_count = 0
        return ng_word_ent
      end
      
      # エラーメッセージ処理
      def error_msg(attr_str, msg, msg_option=Hash.new)
        attr_name = view_text('list.item_names.' + attr_str)
        return validation_msg(attr_name, msg, msg_option)
      end
    end
  end
end