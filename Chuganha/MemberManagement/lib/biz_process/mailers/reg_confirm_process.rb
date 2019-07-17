# -*- coding: utf-8 -*-
###############################################################################
# 業務プロセスクラス
# 概要：仮登録完了通知のメール送信を行う
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/12/08 Nakanohito
# 更新日:
###############################################################################
require 'biz_process/business_process'

module BizProcess::Mailers
  class RegConfirmProcess < BizProcess::BusinessProcess
    # アクセサー
    attr_writer :user_id, :nickname, :mobile_email, :temp_password
    ###########################################################################
    # コンストラクタ
    ###########################################################################
    def initialize
      super('RegConfirmProcess')
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
        NoticeMailer.registration_confirmation(params).deliver
      rescue StandardError=>ex
        @logger.error("Process Error:" + @process_name)
        @logger.error("Exception    :" + ex.class.name)
        @logger.error("Message      :" + ex.message)
        @logger.error("Backtrace    :" + ex.backtrace.join("\n"))
      end
    end
  end
end