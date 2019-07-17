# -*- coding: utf-8 -*-
###############################################################################
# リクエストモッククラス
# Copyright:: Copyright (c) 2012 仲務省
# 作成日:2012/01/10 Nakanohito
# 更新日:
###############################################################################

module Mock
  class MockRequest
    # コンストラクタ
    def initialize(method=:GET)
      @method = method
      @header_hash = Hash.new
      @param_hash = Hash.new
    end
    
    public
    def get?
      return @method == :GET
    end
    
    def request_method
      return @method.to_s
    end
    
    def size
      return @param_hash.size
    end
    
    def headers
      return @header_hash
    end
    alias env headers
    
    def referer
      return @header_hash["HTTP_REFERER"]
    end
    
    def session_options
      return {:id=>@header_hash[:session_id]}
    end
    
    def [](key)
      return @param_hash[key]
    end
    
    def []=(key, value)
      @param_hash[key] = value
    end
  end
end
