# -*- coding: utf-8 -*-
###############################################################################
# 業務プロセスクラス
# 概要：仮更新完了通知のメール送信を行う
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/12/15 Nakanohito
# 更新日:
###############################################################################
require 'biz_process/business_process'

module BizProcess::Mailers
  class UpdConfirmProcess < BizProcess::BusinessProcess
    # アクセサー
    attr_writer :user_id, :nickname, :mobile_email, :temp_password
    ###########################################################################
    # コンストラクタ
    ###########################################################################
    def initialize
      super('UpdConfirmProcess')
      @user_id       = nil
      @nickname      = nil
      @mobile_email  = nil
      @temp_password = nil
    end
    ###########################################################################
    # publicメソッド定義
    ###########################################################################
    public
    # 処理実行
    def execution
      begin
        # 仮登録完了メール送信
        params = {:user_id=>@user_id, :nickname=>@nickname,
                  :mobile_email=>@mobile_email, :temp_password=>@temp_password}
        NoticeMailer.update_confirmation(params).deliver
      rescue StandardError=>ex
        @logger.error("Process Error:" + @process_name)
        @logger.error("Exception    :" + ex.class.name)
        @logger.error("Message      :" + ex.message)
        @logger.error("Backtrace    :" + ex.backtrace.join("\n"))
      end
    end
  end
end