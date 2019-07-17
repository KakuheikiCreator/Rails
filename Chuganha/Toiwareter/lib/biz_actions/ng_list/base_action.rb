# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：NGワード基底アクションクラス
# コントローラー：NGWord::NGListController
# アクション：list
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/01/14 Nakanohito
# 更新日:
###############################################################################
require 'common/session_util_module'
require 'biz_actions/business_action'
require 'data_cache/ng_word_cache'

module BizActions
  module NgList
    class BaseAction < BizActions::BusinessAction
      include Common
      include DataCache
      # リーダー
      attr_reader :ng_word, :replace_word, :list
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        # プロパティ
        @ng_word = @params[:ng_word]
        @replace_word = @params[:replace_word]
        # NGワードリスト
        @list = NgWordCache.instance.ng_word_list
      end
    end
  end
end