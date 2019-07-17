# -*- coding: utf-8 -*-
###############################################################################
# メール生成クラス
# 概要：通知メール送信メーラー
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/11/28 Nakanohito
# 更新日:
###############################################################################
require 'biz_common/business_config'

class NoticeMailer < ActionMailer::Base
  include BizCommon
  default from: BusinessConfig.instance[:admin_mail]
  
  # 仮登録完了通知メール生成
  def registration_confirmation(params)
    # パラメータ取得
    user_id       = params[:user_id]
    nickname      = params[:nickname]
    mobile_email  = params[:mobile_email]
    temp_password = params[:temp_password]
    # OpenIDヘッダーURL
    biz_config = BusinessConfig.instance
    @open_id = biz_config[:open_id_header] + user_id
    @nickname = nickname
    @mobile_email = mobile_email
    # 本登録URL
    site_top = biz_config[:site_top]
    url_header = url_for(:host=>site_top, :controller=>"registration/registration", :action=>"step_7")
    @confirmation_url = url_header + '?guid=on&id=' + user_id + '&cd=' + temp_password
    # 誤登録URL
    url_header = url_for(:host=>site_top, :controller=>"registration/registration", :action=>"miss")
    @miss_data_url = url_header + '?guid=on&id=' + user_id + '&cd=' + temp_password
    #　連絡先アドレス（管理者アドレス）
    @contact_mail = biz_config[:admin_mail]
    return mail(:from=>@contact_mail, :to=>@mobile_email, :subject=>'仮登録完了通知')
  end
  
  # 仮更新完了通知メール生成
  def update_confirmation(params)
    # パラメータ取得
    user_id       = params[:user_id]
    nickname      = params[:nickname]
    mobile_email  = params[:mobile_email]
    temp_password = params[:temp_password]
    # OpenIDヘッダーURL
    biz_config = BusinessConfig.instance
    @open_id = biz_config[:open_id_header] + user_id
    @nickname = nickname
    @mobile_email = mobile_email
    # 更新完了URL
    site_top = biz_config[:site_top]
    url_header = url_for(:host=>site_top, :controller=>"update/update", :action=>"complete")
    @confirmation_url = url_header + '?guid=on&id=' + user_id + '&cd=' + temp_password
    # 誤更新URL
    url_header = url_for(:host=>site_top, :controller=>"update/update", :action=>"miss")
    @miss_data_url = url_header + '?guid=on&id=' + user_id + '&cd=' + temp_password
    #　連絡先アドレス（管理者アドレス）
    @contact_mail = biz_config[:admin_mail]
    return mail(:from=>@contact_mail, :to=>@mobile_email, :subject=>'仮更新完了通知')
  end
end
