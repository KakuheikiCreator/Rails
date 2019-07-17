# -*- coding: utf-8 -*-
###############################################################################
# コントローラーモッククラス
# Copyright:: Copyright (c) 2012 仲務省
# 作成日:2012/01/10 Nakanohito
# 更新日:
###############################################################################
require 'unit/mock/mock_logger'
require 'unit/mock/mock_request'

module Mock
  class MockController < ApplicationController
    # アクセスメソッド定義
    attr_accessor :controller_name, :controller_path, :request, :session, :params,
                  :flash, :redirect_hash, :http_status, :logger
    ###########################################################################
    # メソッド定義
    ###########################################################################
    # コンストラクタ
    def initialize(params={:controller_name => 'MockController', :method=>:GET})
      @controller_name = params[:controller_name]
      @controller_path = params[:controller_path]
      @request = MockRequest.new(params[:method])
      @params = params[:params]
      @params ||= Hash.new
      @session = params[:session]
      @flash = params[:flash]
      @flash ||= Hash.new
      @redirect_hash = Hash.new
      @http_status = nil
      @logger = MockLogger.new
    end
    
    public
    # リダイレクト処理
    def redirect_to(arg1, arg2=nil, arg3=nil)
      if Hash === arg1 then
        @redirect_hash.update(arg1)
      else
        @redirect_hash[:url] = arg1
      end
      if Hash === arg2 then
        @redirect_hash.update(arg2)
      elsif !arg2.nil? then
        @redirect_hash[:status] = arg2
      end
      @redirect_hash[:status] = arg3 unless arg3.nil?
    end
    
    # HTTPステータス
    def head(status)
      @http_status = status
    end
    
    # セッションリセット
    def reset_session
      @session = Hash.new
    end
  end
end
