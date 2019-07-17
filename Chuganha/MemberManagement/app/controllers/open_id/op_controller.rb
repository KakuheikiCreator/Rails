# -*- coding: utf-8 -*-
###############################################################################
# 機能：OpenIDプロバイダ
# クラス：コントローラー
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/11/08 Nakanohito
# 更新日:
###############################################################################
require 'authentication/xrds_message'
require 'biz_actions/open_id/index_action'
require 'biz_actions/open_id/confirmation_form_action'
require 'biz_actions/open_id/confirmation_action'

class OpenId::OpController < ApplicationController
  include Authentication
  include BizActions::OpenId
  layout nil
  
  #############################################################################
  # 初期アクセス
  #############################################################################
  def index
logger.debug('index start user_id:' + session[:user_id].to_s)
    IndexAction.new(self).index_action
  end

  #############################################################################
  # XRDS（プロバイダタイプ）
  #############################################################################
  def idp_xrds
logger.debug('idp_xrds start user_id:' + session[:user_id].to_s)
    render_xrds(OPServer::IDP_TYPES)
  end

  #############################################################################
  # XRDS（サービス情報）
  #############################################################################
  def user_xrds
logger.debug('user_xrds start user_id:' + session[:user_id].to_s)
    render_xrds(OPServer::USER_TYPES)
  end

  #############################################################################
  # ユーザーページ表示
  #############################################################################
  def user_page
logger.debug('user_page start user_id:' + session[:user_id].to_s)
    accept = request.env['HTTP_ACCEPT']
    if !accept.nil? && accept.include?('application/xrds+xml') then
      user_xrds
      return
    end
    @xrds_url = url_for(:controller=>'open_id/op', :action=>'user_xrds',
                        :user_id=>params[:user_id], :only_path=>false)
logger.debug('user_page xrds_url:' + @xrds_url)
    response.headers['X-XRDS-Location'] = @xrds_url
    respond_to do |format|
      format.html {render(:action=>'user_page')}
    end
  end
  
  #############################################################################
  # RPを信用確認ページを表示
  #############################################################################
  def confirmation_form
logger.debug('confirmation_form start user_id:' + session[:user_id].to_s)
    @biz_obj = ConfirmationFormAction.new(self)
    @page_title = view_text('confirmation_form.item_names.page_titile')
    @page_title_image = 'open_id/confirmation_title.jpg'
    respond_to do |format|
      format.html {
        if @biz_obj.form_action? then
          render(:action=>'confirmation_form', :layout=>'layout_1')
        else
          render(:text=>"This is an OpenID server endpoint.")
        end
      }
    end
  end
  
  #############################################################################
  # RPの信頼確認
  #############################################################################
  def confirmation
logger.debug('confirmation start user_id:' + session[:user_id].to_s)
    @biz_obj = ConfirmationAction.new(self)
    @biz_obj.confirmation
  end

  #############################################################################
  # protected定義
  #############################################################################
  protected
  # XRDSレスポンス処理
  def render_xrds(types)
    response.headers['content-type'] = 'application/xrds+xml'
    svr_url = url_for(:controller=>'open_id/op', :only_path=>false)
    render :text => XRDSMessage.new(types, svr_url).to_s
  end
end
