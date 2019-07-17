# -*- coding: utf-8 -*-
###############################################################################
# 機能：ログイン
# クラス：コントローラー
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2012/11/14 Nakanohito
# 更新日:
###############################################################################
require 'filter/method_regulation/method_regulation_filter'
require 'biz_actions/open_id/start_action'
require 'biz_actions/open_id/complete_action'

class OpenId::RpController < ApplicationController
  include Authentication
  include Common
  include Filter::MethodRegulation
  include BizActions::OpenId
  # レイアウト定義
  layout nil
  # フィルタ設定
  before_filter MethodRegulationFilter.new(:POST), :except=>['index', 'complete']
  
  # ログインフォーム表示
  def index
    @open_id = ''
    @error_msg_hash = Hash.new
    # render an Login form
    respond_to do |format|
      format.html {render :action=>'index', :layout=>'layout_1'}
    end
  end
  
  # OpenID認証開始
  def start
    # OpenID認証開始処理
    @biz_obj = StartAction.new(self)
    @biz_obj.start
    @open_id = @biz_obj.open_id
    @error_msg_hash = @biz_obj.error_msg_hash
    case @biz_obj.result_ptn
    when StartAction::PTN_INVALID then
      render :action=>'index', :layout=>'layout_1'
    when StartAction::PTN_REDIRECT then
      # OPへ通常のリダイレクト
      redirect_to @biz_obj.oidreq.redirect_url(@biz_obj.realm, @biz_obj.return_to)
    when StartAction::PTN_POST_REDIRECT then
      # Javascriptを埋め込んだレスポンスを返して、OPへPOSTでリダイレクト
      render :text=>@biz_obj.oidreq.html_markup(@biz_obj.realm, @biz_obj.return_to, {'id' => 'openid_form'})
    end
  end
  
  # 認証結果判定
  def complete
    @biz_obj = CompleteAction.new(self)
    @biz_obj.complete
    @open_id = @biz_obj.open_id
    @error_msg_hash = @biz_obj.error_msg_hash
    case @biz_obj.result_ptn
    when CompleteAction::PTN_SUCCESS then
      redirect_to_home
    when CompleteAction::PTN_SUCCESS_NEW then
      redirect_to_admission
    else
      respond_to do |format|
        format.html {render :action=>'index', :layout=>'layout_1'}
      end
    end
  end
  
  # 新規会員登録にリダイレクト
  def redirect_to_admission
    flash[:redirect_flg] = true
    flash[:params] =
      SessionUtilModule.create_scr_trans_params(self, SessionUtilModule::TRANS_PTN_CLH)
    redirect_to(:controller=>"admission/admission", :action=>"form")
  end
end
