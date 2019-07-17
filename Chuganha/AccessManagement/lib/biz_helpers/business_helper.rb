# -*- coding: utf-8 -*-
###############################################################################
# 業務ヘルパークラス
# 概要：画面編集の際に利用するヘルパーロジックを実装する
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/08/05 Nakanohito
# 更新日:
###############################################################################
require 'application_helper'

module BizHelpers
  class BusinessHelper
    include ApplicationHelper
    # リーダー
    attr_reader :controller_path, :controller_name,
                :params, :request, :session,
                :function_state, :function_state_hash
    
    ###########################################################################
    # コンストラクタ
    ###########################################################################
    def initialize(controller)
      # ヘルパーオブジェクト取得
      @helpers = controller.class.helpers
      # コントローラー関係
      @controller_path = controller.controller_path
      @controller_name = controller.controller_name
      # リクエスト関係
      @request = controller.request
      @params = controller.flash[:params]
      @params ||= controller.params
      # セッション関係
      @session = controller.session
      @function_state_hash = @session[:function_state_hash]
      @function_state = @session[:function_state]
    end
    ###########################################################################
    # publicメソッド定義
    ###########################################################################
    public
    # 定義していないメソッド呼び出しがされた場合
    def method_missing(name, *args, &block)
      return @helpers.__send__(name, *args) if block.nil?
      return @helpers.__send__(name, *args, block)
    end
  end
end