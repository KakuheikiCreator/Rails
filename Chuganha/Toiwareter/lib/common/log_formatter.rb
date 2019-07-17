# -*- coding: utf-8 -*-
###############################################################################
# ログフォーマッタクラス
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2011/07/06 Nakanohito
# 更新日:
###############################################################################
module Common
  class LogFormatter < Logger::Formatter
    Format = "[%s] %s:%s: %s\n"

    # ログメッセージのフォーマット
    def call(severity, time, progname, msg)
      return Format % [format_datetime(time), format_severity(severity), progname, msg2str(msg)]
    end

    protected

    # ログレベルのフォーマット
    def format_severity(severity)
      return severity.ljust(5)
    end

    # 日時のフォーマット
    def format_datetime(time)
      return time.strftime("%Y-%m-%d %H:%M:%S")
    end
  end
end