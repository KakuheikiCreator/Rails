# -*- coding: utf-8 -*-
###############################################################################
# デバッグ用ロガークラス
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/12/04 Nakanohito
# 更新日:
###############################################################################
require 'singleton'

module Common
  class DebugLogger
    include Singleton
    Format = "[%s] %s:%s: %s\n"
    ###########################################################################
    # コンストラクタ
    ###########################################################################
    # 初期処理
    def initialize
      # 排他制御オブジェクト生成
      @mutex = Mutex.new
      @log_file_name = (Rails.root + 'log/debug.log').to_s
    end
    
    ###########################################################################
    # publicメソッド定義
    ###########################################################################
    public
    # ログメッセージ出力(DEBUG)
    def debug(msg)
      log_msg = log_msg('DEBUG', Time.now, '', msg)
      @mutex.synchronize do
        log_write(log_msg)
      end
    end
    
    # ログメッセージ出力(ERROR)
    def error(msg)
      log_msg = log_msg('ERROR', Time.now, '', msg)
      @mutex.synchronize do
        log_write(log_msg)
      end
    end

    ###########################################################################
    # protectedメソッド定義
    ###########################################################################
    protected
    # ログメッセージのフォーマット
    def log_msg(severity, time, progname, msg)
      return Format % [format_datetime(time), format_severity(severity), progname, msg.to_s]
    end
    
    # ログ書き込み処理
    def log_write(log_msg)
      log_file = open(@log_file_name, "a")
      log_file.write(log_msg)
      log_file.close
   end

    # ログレベルのフォーマット
    def format_severity(severity)
      return severity.ljust(5)
    end

    # 日時のフォーマット
    def format_datetime(time)
      return time.strftime("%Y-%m-%d %H:%M:%S.%L")
    end
  end
end