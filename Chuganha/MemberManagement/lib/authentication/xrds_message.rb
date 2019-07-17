# -*- coding: utf-8 -*-
###############################################################################
# XRDSメッセージクラス
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/10/27 Nakanohito
# 更新日:
###############################################################################
module Authentication
  class XRDSMessage
    ###########################################################################
    # メソッド定義
    ###########################################################################
    # 初期化メソッド
    def initialize(msg_types, svr_url)
      # メッセージタイプ
      @msg_types = msg_types
      # サーバーURL
      @svr_url = svr_url
      # XRDSメッセージ
      @xrds_msg = create_xrds(msg_types, svr_url)
    end
    
    ###########################################################################
    # public定義
    ###########################################################################
    public
    # 文字列化
    def to_s
      return @xrds_msg.to_s
    end
    
    ###########################################################################
    # protected定義
    ###########################################################################
    protected
    # 送信XML生成
    def create_xrds(types, server_url)
      xrds_xml = REXML::Document.new
      xrds_xml.add(REXML::XMLDecl.new(version="1.0", encoding="utf-8"))
      # 本文編集
      root = xrds_xml.add_element("xrds:XRDS", {"xmlns:xrds"=>"xri://$xrds", "xmlns"=>"xri://$xrd*($v*2.0)"})
      xrd_elm = root.add_element("XRD")
      service_elm = xrd_elm.add_element("Service", {"priority"=>"0"})
      types.each do |uri|
        service_elm.add_element("Type").text = uri
      end
      uri_elm = service_elm.add_element("URI")
      uri_elm.text = server_url
      return xrds_xml
    end
  end
end