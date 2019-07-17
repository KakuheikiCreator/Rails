# -*- coding: utf-8 -*-
###############################################################################
# 機能：メニュー
# クラス：コントローラー
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/02/01 Nakanohito
# 更新日:
###############################################################################
require 'filter/method_regulation/method_regulation_filter'
require 'filter/update_session/update_session_filter'

class Menu::MenuController < ApplicationController
  include Filter::MethodRegulation
  include Filter::UpdateSession
  # フィルタ設定
  before_filter MethodRegulationFilter.new(:POST)
  around_filter UpdateSessionFilter.new
  
  # メニュー画面表示
  def menu
    respond_to do |format|
      format.html # menu.html.erb
    end
  end
end
