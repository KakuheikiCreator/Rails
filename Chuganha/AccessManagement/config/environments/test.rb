# -*- coding: utf-8 -*-
###############################################################################
# 環境変数設定:: テスト環境
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/01/16 Nakanohito  (mailto:)
# 更新日:
###############################################################################
require 'common/log_formatter'

AccessManagement::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # The test environment is used exclusively to run your application's
  # test suite. You never need to work with it otherwise. Remember that
  # your test database is "scratch space" for the test suite and is wiped
  # and recreated between test runs. Don't rely on the data there!
  config.cache_classes = true

  # Configure static asset server for tests with Cache-Control for performance
  config.serve_static_assets = true
  config.static_cache_control = "public, max-age=3600"

  # Log error messages when you accidentally call methods on nil
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Raise exceptions instead of rendering exception templates
  config.action_dispatch.show_exceptions = false

  # Disable request forgery protection in test environment
  config.action_controller.allow_forgery_protection    = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test

  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict

  # Print deprecation notices to the stderr
  config.active_support.deprecation = :stderr
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
