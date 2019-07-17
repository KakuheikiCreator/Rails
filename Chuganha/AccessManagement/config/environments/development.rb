# -*- coding: utf-8 -*-
###############################################################################
# 環境変数設定:: 開発環境
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/01/16 Nakanohito  (mailto:)
# 更新日:
###############################################################################
require 'common/log_formatter'

AccessManagement::Application.configure do
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
  config.action_mailer.raise_delivery_errors = false

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
  # 10MB毎にローテートする。
  config.logger = Logger.new(File.join( Rails.root, 'log', "#{Rails.env}.log" ), 1, 1024 * 1024 * 10)
  # ログフォーマッタ設定
  config.logger.formatter = Common::LogFormatter.new
  # ログレベルをデバッグにする。
  config.log_level = Logger::DEBUG
  # メッセージの着色OFF
  config.colorize_logging = false
end
