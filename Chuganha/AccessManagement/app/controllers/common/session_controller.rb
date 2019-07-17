# -*- coding: utf-8 -*-
###############################################################################
# 機能：共通セッション処理
# クラス：コントローラー
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/03/14 Nakanohito
# 更新日:
###############################################################################
require 'filter/method_regulation/method_regulation_filter'
require 'filter/update_session/update_session_filter'

class Common::SessionController < ApplicationController
  include Filter::MethodRegulation
  include Filter::UpdateSession
  # レイアウト定義
  layout nil
  # フィルタ設定
  before_filter MethodRegulationFilter.new(:POST)
  before_filter :host_regulation, :except=>['clear', 'logout']
  around_filter UpdateSessionFilter.new, :except=>['sweep']
  
  # セッションクリア
  def clear
    render :text=>"ok", :status=>200
  end
  
  # ログアウトセッション
  def logout
    # セッションクリア
    reset_session
    respond_to do |format|
      format.html {redirect_to_front}
    end
  end
  
  # タイムアウトセッションクリア
  def sweep
    # ３時間以上経ったセッション情報は削除
    ActiveRecord::SessionStore::Session.where("updated_at < ?", 3.hours.ago).delete_all
    logger.info('Session Sweep!')
    render :text=>"ok", :status=>200
  end

  # リクエストホストによるフィルタ処理
  def host_regulation
    # ローカルホストからのリクエストのみ許容
    unless request.remote_ip == "127.0.0.1" then
      render_404
      return
    end
  end
end
