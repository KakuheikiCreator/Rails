# -*- coding: utf-8 -*-
###############################################################################
# メッセージ処理業務初期処理
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/04/11 Nakanohito
# 更新日:
###############################################################################
require 'messaging/msg_process_manager'
require 'biz_message_process/biz_test_process'
require 'biz_message_process/biz_refresh_schedule'
require 'biz_message_process/biz_refresh_reg_cookie'
require 'biz_message_process/biz_refresh_reg_host'
require 'biz_message_process/biz_refresh_reg_referrer'
# 処理マネージャー生成
manager = Messaging::MsgProcessManager.instance
# メッセージ処理割り当て
manager['TestProc'] = BizMessageProcess::BizTestProcess.new
manager['DUN001'] = BizMessageProcess::BizRefreshSchedule.new
manager['DUN002'] = BizMessageProcess::BizRefreshRegCookie.new
manager['DUN003'] = BizMessageProcess::BizRefreshRegHost.new
manager['DUN004'] = BizMessageProcess::BizRefreshRegReferrer.new
