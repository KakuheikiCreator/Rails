# -*- coding: utf-8 -*-
###############################################################################
# HTTPクライアントモッククラス
# Copyright:: Copyright (c) 2012 仲務省
# 作成日:2012/05/31 Nakanohito
# 更新日:
###############################################################################

module Mock
  class MockHTTPClient
    # アクセスメソッド定義
    attr_reader :request_array
    # コンストラクタ
    def initialize
      @request_array = Array.new
    end
    
    ###########################################################################
    # public定義
    ###########################################################################
    public
    # POSTメソッド
    def post(url, post_data)
      # リクエストリスト
      request_info = RequestInfo.new(url, post_data)
      @request_array.push(request_info)
      return create_response(request_info)
    end
    
    ###########################################################################
    # protected定義
    ###########################################################################
    protected
    # レスポンス生成処理
    def create_response(request_info)
      return ResponseInfo.new(200, '')
    end
    
    ###########################################################################
    # リクエスト情報
    ###########################################################################
    class RequestInfo
      # アクセスメソッド定義
      attr_reader :received, :uri, :post_data
      # コンストラクタ
      def initialize(uri, post_data)
        @received = Time.new
        @uri = uri
        @post_data = post_data
      end
    end
    
    ###########################################################################
    # レスポンス情報
    ###########################################################################
    class ResponseInfo
      # アクセスメソッド定義
      attr_reader :status, :body
      # コンストラクタ
      def initialize(status, body)
        @status = status.to_i
        @body = body
      end
    end
  end
end
