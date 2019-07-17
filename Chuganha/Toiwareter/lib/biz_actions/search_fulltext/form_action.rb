# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：全文検索フォーム表示アクションクラス
# コントローラー：Search::FulltextController
# アクション：form
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/02/10 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/search_fulltext/base_action'

module BizActions
  module SearchFulltext
    class FormAction < BizActions::SearchFulltext::BaseAction
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
      end
    end
  end
end