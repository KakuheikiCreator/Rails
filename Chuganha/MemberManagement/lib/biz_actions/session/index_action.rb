# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：ログインフォーム表示アクション
# コントローラー：Session::SessionController
# アクション：index
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2013/01/03 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/business_action'

module BizActions
  module Session
    class IndexAction < BizActions::BusinessAction
      # アクセサー定義
      attr_reader :open_id
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        # OpenIDリクエスト
        @open_id_request = @controller.session[:last_oidreq]
        @open_id = nil
        @open_id = @open_id_request.identity unless @open_id_request.nil?
      end
    end
  end
end