# -*- coding: utf-8 -*-
###############################################################################
# 機能：ログイン
# クラス：コントローラー
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/01/30 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/login/login_action'
require 'common/session_util_module'
require 'filter/method_regulation/method_regulation_filter'
require 'filter/update_session/update_session_filter'

class Login::LoginController < ApplicationController
  include BizActions::Login
  include Common
  include Filter::MethodRegulation
  include Filter::UpdateSession
  # フィルタ設定
  before_filter MethodRegulationFilter.new(:POST), :except=>['form']
  around_filter UpdateSessionFilter.new, :except=>['form']
  
  #############################################################################
  # public定義
  #############################################################################
  public
  # Loginフォーム画面表示
  def form
    # セッションの初期化
    @err_msg = nil
    if session[:login_id].nil? then
      # 未ログイン状態
      SessionUtilModule.function_state_init?(self)
    else
      # ログイン済み状態
      redirect_to_menu
    end
  end
  
  # Login処理
  def login
    login_action = LoginAction.new(self)
    if login_action.valid? then
      # 有効なアカウントの場合
      session[:login_id] = login_action.login_id
      redirect_to_menu
      return
    end
    # 無効なアカウントの場合
    @err_msg = login_action.error_msg_hash[:err_msg]
    SessionUtilModule.function_state_init?(self)
    render :action=>'form'
  end
  
  # Logout処理
  def logout
    # セッション初期化
    SessionUtilModule.function_state_init?(self)
    @err_msg = nil
    render :action=>'form'
  end
  
  #############################################################################
  # protected定義
  #############################################################################
  protected
  def redirect_to_menu
    flash[:redirect_flg] = true
    flash[:params] =
      SessionUtilModule.create_scr_trans_params(self, SessionUtilModule::TRANS_PTN_CLH)
    redirect_to(:controller=>"menu/menu", :action=>"menu")
  end
end
