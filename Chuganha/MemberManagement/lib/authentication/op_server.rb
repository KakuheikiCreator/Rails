# -*- coding: utf-8 -*-
###############################################################################
# OpenIDサーバー
# 概要：OpenIDプロバイダの機能を提供するクラス
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/11/09 Nakanohito
# 更新日:
###############################################################################
require 'singleton'
require 'thread'
require 'openid'
require 'openid/extensions/sreg'
require 'openid/store/filesystem'
require 'biz_common/business_config'

module Authentication
  class OPServer
    include Singleton
    include OpenID
    include OpenID::Server
    include BizCommon
    ###########################################################################
    # 定数
    ###########################################################################
    # プロバイダタイプ
    IDP_TYPES = [OpenID::OPENID_IDP_2_0_TYPE]
    # 対応サービスタイプ
    USER_TYPES = [OpenID::OPENID_1_0_TYPE, OpenID::OPENID_2_0_TYPE, OpenID::SREG_URI]

    ###########################################################################
    # コンストラクタ
    ###########################################################################
    def initialize
      # 排他制御オブジェクト生成
      @mutex = Mutex.new
      # 業務設定
      @biz_config = BusinessConfig.instance
      # サーバーオブジェクト生成
      @server = create_server
    end
    
    ###########################################################################
    # public定義
    ###########################################################################
    public
    # リクエストデコード
    def decode_request(params)
      @mutex.synchronize do
        return @server.decode_request(params)
      end
    end
    
    # レスポンスのエンコード
    def encode_response(oidresp)
      @mutex.synchronize do
        return @server.encode_response(oidresp)
      end
    end
    
    # SREGリクエスト抽出
    def ex_sreg_request(oidreq)
      @mutex.synchronize do
        return OpenID::SReg::Request.from_openid_request(oidreq)
      end
    end
    
    # ユーザー属性情報付加
    def add_sreg(oidresp, sregreq, sreg_data)
      @mutex.synchronize do
        sregresp = OpenID::SReg::Response.extract_response(sregreq, sreg_data)
        oidresp.add_extension(sregresp)
      end
    end
    
    # リクエスト処理
    def handle_request(oidresp)
      @mutex.synchronize do
        return @server.handle_request(oidresp)
      end
    end
    
    # レスポンス署名
    def resp_sign?(oidresp)
      @mutex.synchronize do
        return false unless oidresp.needs_signing
        @server.signatory.sign(oidresp)
        return true
      end
    end
    
    ###########################################################################
    # protected定義
    ###########################################################################
    protected
    # OpenIDサーバーオブジェクト生成
    def create_server
      dir = Pathname.new(Rails.root.to_s).join('db').join('openid-store')
      store = OpenID::Store::Filesystem.new(dir)
#      store = ActiveRecordStore.new
      return Server.new(store, @biz_config[:op_server_url])
    end
  end
end