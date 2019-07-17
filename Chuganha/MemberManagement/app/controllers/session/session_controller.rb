# -*- coding: utf-8 -*-
###############################################################################
# 機能：セッション管理
# クラス：コントローラー
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/11/17 Nakanohito
# 更新日:
###############################################################################
require 'filter/method_regulation/method_regulation_filter'
require 'filter/user_regulation/user_regulation_filter'
require 'filter/update_session/update_session_filter'
require 'biz_actions/session/index_action'
require 'biz_actions/session/login_action'

class Session::SessionController < ApplicationController
  include Filter::MethodRegulation
  include Filter::UserRegulation
  include Filter::UpdateSession
  include BizActions::Session
  # フィルタ設定
  before_filter MethodRegulationFilter.new(:POST), :except=>['index']
  before_filter UserRegulationFilter.new, :except=>['index', 'login']
  around_filter UpdateSessionFilter.new, :except=>['index', 'login', 'logout']
  
  # ログインフォーム表示
  def index
    @biz_obj = IndexAction.new(self)
    @page_title = view_text('index.item_names.page_titile')
    @page_title_image = 'session/login_title.jpg'
    @error_msg_hash = Hash.new
    respond_to do |format|
      format.html {render(:action=>'index', :layout=>'layout_1')}
    end
  end
  
  # ログイン認証処理
  def login
    @biz_obj = LoginAction.new(self)
    @page_title = view_text('index.item_names.page_titile')
    @page_title_image = 'session/login_title.jpg'
    @error_msg_hash = @biz_obj.error_msg_hash
    respond_to do |format|
      format.html {
        # バリデーションチェック
        unless @biz_obj.login? then
          render(:action=>'index', :layout=>'layout_1')
          return
        end
        if @biz_obj.ex_site_auth? then
          redirect_to(:controller=>"open_id/op", :action=>"confirmation_form")
        else
          redirect_to_home
        end
      }
    end
  end
  
  # ログアウト処理
  def logout
    # セッションクリア
    reset_session
    respond_to do |format|
      format.html {redirect_to_front}
    end
  end
end
