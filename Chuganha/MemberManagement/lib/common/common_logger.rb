# -*- coding: utf-8 -*-
###############################################################################
# 共通ロガークラス
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/12/23 Nakanohito
# 更新日:
###############################################################################
require 'singleton'
require 'thread'

module Common
  class CommonLogger
    include Singleton
    # 定数定義
    Format = "[%s] %s:%s: %s\n"
    LOG_LEVEL_FATAL = 0
    LOG_LEVEL_ERROR = 1
    LOG_LEVEL_WARN  = 2
    LOG_LEVEL_INFO  = 3
    LOG_LEVEL_DEBUG = 4
    ###########################################################################
    # コンストラクタ
    ###########################################################################
    # 初期処理
    def initialize
      # 排他制御オブジェクト生成
      @mutex = Mutex.new
      # ログ出力レベル
      @log_level = LOG_LEVEL_DEBUG
      # 最大ファイル数
      @max_backups = 0
      # 最大ファイルサイズ（100MB）
      @max_size = 1024 * 1024 * 100
      # レベル名初期化
      @levle_hash = Hash.new
      @levle_hash[LOG_LEVEL_FATAL] = 'FATAL'
      @levle_hash[LOG_LEVEL_ERROR] = 'ERROR'
      @levle_hash[LOG_LEVEL_WARN]  = 'WARN '
      @levle_hash[LOG_LEVEL_INFO]  = 'INFO '
      @levle_hash[LOG_LEVEL_DEBUG] = 'DEBUG'
      # ログファイル名初期化
      @log_file_name_hash = Hash.new
      @log_file_name_hash[LOG_LEVEL_FATAL] = log_file_path('common.log')
      @log_file_name_hash[LOG_LEVEL_ERROR] = log_file_path('common.log')
      @log_file_name_hash[LOG_LEVEL_WARN]  = log_file_path('common.log')
      @log_file_name_hash[LOG_LEVEL_INFO]  = log_file_path('common.log')
      @log_file_name_hash[LOG_LEVEL_DEBUG] = log_file_path('common.log')
      # 最新バックアップファイル番号ハッシュ
      @backups_number_hash = Hash.new
      # 解析スレッド生成
      @log_queue  = Queue.new
      @log_thread = create_log_thread
    end
    
    ###########################################################################
    # publicメソッド定義
    ###########################################################################
    public
    # ファイル名設定
    def filename(file_name, log_level=nil)
      @mutex.synchronize do
        return unless String === file_name
        unless log_level.nil? then
          return unless @log_file_names.key?(log_level)
        end
        level_list = @log_file_names.keys
        level_list.each do |level|
          if log_level.nil? || level == log_level then
            @log_file_names[level] = log_file_path(file_name)
          end
        end
      end
    end
    
    # ファイル名設定
    def log_level(new_log_level)
      @mutex.synchronize do
        return unless @log_file_names.key?(new_log_level)
        @log_level = new_log_level
      end
    end
    
    # ログメッセージ出力(FATAL)
    def fatal(msg, prgname='')
      @mutex.synchronize do
        # スレッドの状態判定
        @log_thread = create_log_thread unless @log_thread.alive?
        @log_queue.push(LogParameters.new(LOG_LEVEL_FATAL, Time.now, prgname, msg))
      end
    end
    
    # ログメッセージ出力(ERROR)
    def error(msg, prgname='')
      @mutex.synchronize do
        return if @log_level < LOG_LEVEL_ERROR
        # スレッドの状態判定
        @log_thread = create_log_thread unless @log_thread.alive?
        @log_queue.push(LogParameters.new(LOG_LEVEL_ERROR, Time.now, prgname, msg))
      end
    end
    
    # ログメッセージ出力(WARN)
    def warn(msg, prgname='')
      @mutex.synchronize do
        return if @log_level < LOG_LEVEL_WARN
        # スレッドの状態判定
        @log_thread = create_log_thread unless @log_thread.alive?
        @log_queue.push(LogParameters.new(LOG_LEVEL_WARN, Time.now, prgname, msg))
      end
    end
    
    # ログメッセージ出力(INFO)
    def info(msg, prgname='')
      @mutex.synchronize do
        return if @log_level < LOG_LEVEL_INFO
        # スレッドの状態判定
        @log_thread = create_log_thread unless @log_thread.alive?
        @log_queue.push(LogParameters.new(LOG_LEVEL_INFO, Time.now, prgname, msg))
      end
    end
    
    # ログメッセージ出力(DEBUG)
    def debug(msg, prgname='')
      @mutex.synchronize do
        return if @log_level < LOG_LEVEL_DEBUG
        # スレッドの状態判定
        @log_thread = create_log_thread unless @log_thread.alive?
        @log_queue.push(LogParameters.new(LOG_LEVEL_DEBUG, Time.now, prgname, msg))
      end
    end

    ###########################################################################
    # protectedメソッド定義
    ###########################################################################
    protected
    # ログファイルパス生成
    def log_file_path(filename)
      return (Rails.root + 'log/' + filename).to_s
    end
    
    # ログ出力スレッド生成
    def create_log_thread
      return Thread.start do
        params = @log_queue.pop
        until params.nil? do
          log_write(params)
          params = @log_queue.pop
        end
      end
    end
    
    # ログ書き込み処理
    def log_write(params)
      # ローテーション処理
      file_rotation(params.log_level)
      message  = log_msg(params.log_level, params.log_time, params.log_progname, params.log_msg)
      log_file = open(@log_file_name_hash[params.log_level], "a")
      log_file.write(message)
      log_file.close
    end
    
    # ログメッセージのフォーマット
    def log_msg(level, time, progname, msg)
      time_msg = time.strftime("%Y-%m-%d %H:%M:%S.%L")
      return Format % [time_msg, @levle_hash[level], progname, msg.to_s]
    end
    
    # ファイルローテーション処理
    def file_rotation(log_level)
      log_file_name = @log_file_name_hash[log_level]
      return unless File.exist?(log_file_name)
      file_state = File::stat(log_file_name)
      return if file_state.size <= @max_size
      if @max_backups == 0 then
        # 既存ログファイルの削除
        File.delete(log_file_name)
        return
      end
      # バックアップファイル名生成
      backups_number = @backups_number_hash[log_level]
      backups_number ||= 0
      backups_number = 0 if backups_number >= @max_backups
      backups_number += 1
      back_file_name = log_file_name.gsub(/\.log$/, '') + backups_number.to_s.rjust(5,"0") + '.log'
      # 既存バックアップファイルの削除
      File.delete(back_file_name) if File.exist?(back_file_name)
      # 現在ログファイルのリネーム
      File.rename(log_file_name, back_file_name)
      # 最新バックアップファイル番号更新
      @log_file_name_hash.each do |key, value|
        @backups_number_hash[key] = backups_number if value == log_file_name
      end
    end
    
    # ログパラメータクラス
    class LogParameters
      # アクセサー
      attr_reader :log_level, :log_time, :log_progname, :log_msg
      # 初期処理
      def initialize(level, time, progname, msg)
        @log_level = level
        @log_time  = time
        @log_progname = progname
        @log_msg   = msg
      end
    end
  end
end