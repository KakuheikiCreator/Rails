# -*- coding: utf-8 -*-
###############################################################################
# Relying Partyクライアント
# 概要：Relying Partyの機能を提供するクラス
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2012/11/14 Nakanohito
# 更新日:
###############################################################################
require 'openid'
require 'openid/extensions/sreg'
require 'openid/store/filesystem'

module Authentication
  class AuthConsumer
    include OpenID
    ###########################################################################
    # コンストラクタ
    ###########################################################################
    def initialize(session)
      # RPオブジェクト生成
      @consumer = create_consumer(session)
    end
    
    ###########################################################################
    # public定義
    ###########################################################################
    public
    # リクエスト生成
    def request(identifier)
      return @consumer.begin(identifier)
    end
    
    # SREGリクエスト生成
    def sreg_request(fields)
      sregreq = SReg::Request.new
      sregreq.request_fields(fields, true)
      return sregreq
    end
    
    # SREGレスポンス生成
    def sreg_response(oidresp)
      return SReg::Response.from_success_response(oidresp)
    end
    
    # OPからのレスポンス生成
    def complete(parameters, current_url)
      return @consumer.complete(parameters, current_url)
    end
    
    ###########################################################################
    # protected定義
    ###########################################################################
    protected
    # RPオブジェクト生成
    def create_consumer(session)
      dir = Pathname.new(Rails.root).join('db').join('cstore')
      store = Store::Filesystem.new(dir)
#      store = ActiveRecordStore.new
      return Consumer.new(session, store)
    end
  end
end