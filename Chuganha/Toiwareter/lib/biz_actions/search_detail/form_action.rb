# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：詳細検索フォーム表示アクションクラス
# コントローラー：Search::DetailController
# アクション：form
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/03/03 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/search_detail/base_action'

module BizActions
  module SearchDetail
    class FormAction < BizActions::SearchDetail::BaseAction
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
      end
    end
  end
end