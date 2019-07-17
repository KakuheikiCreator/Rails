# -*- coding: utf-8 -*-
###############################################################################
# モックロガークラス
# Copyright:: Copyright (c) 2012 仲務省
# 作成日:2012/01/27 Nakanohito
# 更新日:
###############################################################################

module Mock
  class MockLogger
    # アクセサーメソッド
    attr_reader :unknown_msg_list, :fatal_msg_list, :error_msg_list,
                :warn_msg_list, :info_msg_list, :debug_msg_list
    # コンストラクタ
    def initialize
      @unknown_msg_list = Array.new
      @fatal_msg_list   = Array.new
      @error_msg_list   = Array.new
      @warn_msg_list    = Array.new
      @info_msg_list    = Array.new
      @debug_msg_list   = Array.new
    end
    
    public
    # unknown
    def unknown(msg)
      @unknown_msg_list.push(msg)
    end
    # fatal
    def fatal(msg)
      @fatal_msg_list.push(msg)
    end
    # error
    def error(msg)
      @error_msg_list.push(msg)
    end
    # warn
    def warn(msg)
      @warn_msg_list.push(msg)
    end
    # info
    def info(msg)
      @info_msg_list.push(msg)
    end
    # debug
    def debug(msg)
      @debug_msg_list.push(msg)
    end
  end
end
