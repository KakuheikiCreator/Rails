# -*- coding: utf-8 -*-
###############################################################################
# 機能：会員ホーム
# クラス：コントローラー
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/12/10 Nakanohito
# 更新日:
###############################################################################
require 'filter/method_regulation/method_regulation_filter'
require 'filter/user_regulation/user_regulation_filter'
require 'filter/update_session/update_session_filter'
require 'biz_actions/home/home_action'
require 'function_state/hash_state'

class Home::HomeController < ApplicationController
  include Filter::MethodRegulation
  include Filter::UserRegulation
  include Filter::UpdateSession
  include BizActions::Home
  # レイアウト未指定
  layout nil
  # フィルタ設定
  before_filter MethodRegulationFilter.new(:POST)
  before_filter UserRegulationFilter.new
  around_filter UpdateSessionFilter.new
  
  #############################################################################
  # publicメソッド定義
  #############################################################################
  public
  # 会員ホーム表示
  def home
    @biz_obj = HomeAction.new(self)
    @page_title = view_text('home.item_names.page_titile')
    @page_title_image = 'home/home_title.jpg'
    @error_msg_hash = @biz_obj.error_msg_hash
    respond_to do |format|
      format.html {render :action=>'home', :layout=>'layout_1'}
    end
  end
  
  # 機能状態生成
  def create_function_state(cntr_path, new_trans_no, prev_trans_no, sept_flg)
    return FunctionState::HashState.new(cntr_path, new_trans_no, prev_trans_no, sept_flg)
  end
end
