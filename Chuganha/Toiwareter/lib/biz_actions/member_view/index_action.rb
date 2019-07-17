# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：会員ビュー表示アクションクラス
# コントローラー：Member::ViewController
# アクション：index
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/01/23 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/business_action'
require 'data_cache/member_cache'

module BizActions
  module MemberView
    class IndexAction < BizActions::BusinessAction
      include DataCache
      # リーダー
      attr_reader :member_id, :member
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        # MemberID
        @member_id = @params[:member_id]
        # プロパティ
        @member = MemberCache.instance[@member_id]
      end
    end
  end
end