# -*- coding: utf-8 -*-
###############################################################################
# 環境変数設定:: 開発環境
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/10/26 Nakanohito  (mailto:)
# 更新日:
###############################################################################
require 'common/log_formatter'

MemberManagement::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.smtp_settings = {
    :address=>'smtp.gmail.com',
    :port=>587,
#    :domain => "localhost.localdomain", # ドメイン設定してなければコメントアウトしてＯＫ
    :authentication => :login,
    :user_name => 'gladiatornakayan@gmail.com',
    :password => "nSdn]\"k53ue@sE@'VGMK,j#41[9bEZ!\""
  }

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  config.active_record.auto_explain_threshold_in_seconds = 0.5

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true
  #############################################################################
  # ログ設定
  #############################################################################
  # フォーマッター設定
#  formatter = Log4r::PatternFormatter.new(:pattern => "%d %C [%l]: %M",
#                                          :date_format => "%Y/%m/%d %H:%M:%S")
  # ロガー設定
#  config.logger = Log4r::Logger.new(Rails.application.class.parent_name)
  # コンソール出力
#  cons_outputter = Log4r::StdoutOutputter.new(STDOUT, :formatter=>formatter)
#  config.logger.add(cons_outputter)
  # ファイル出力（ローテーションする）
#  log_file_name = File.expand_path("log/#{Rails.env}.log", Rails.root)
#  output_param = {:filename=>log_file_name, :formatter=>formatter, :max_backups=>3, :maxsize=>1024*1024*10}
#  file_outputter = Log4r::RollingFileOutputter.new('file', output_param)
#  config.logger.add(file_outputter)
  # 出力禁止パラメータ
#  config.filter_parameters += [:password]
  # ログレベル（DEBUG）
#  config.log_level = :debug
  # 10MB毎にローテートする。
  config.logger = Logger.new(File.join( Rails.root, 'log', "#{Rails.env}.log" ), 1, 1024 * 1024 * 10)
  # ログフォーマッタ設定
  config.logger.formatter = Common::LogFormatter.new
  # ログレベルをデバッグにする。
  config.log_level = Logger::DEBUG
  # メッセージの着色OFF
  config.colorize_logging = false
  # 出力禁止パラメータ
  config.filter_parameters += [:password]
end
