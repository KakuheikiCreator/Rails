# -*- coding: utf-8 -*-
###############################################################################
# 機能：会員ホーム
# クラス：コントローラー
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/01/07 Nakanohito
# 更新日:
###############################################################################
require 'filter/method_regulation/method_regulation_filter'
require 'filter/member_regulation/member_regulation_filter'
require 'filter/update_session/update_session_filter'
require 'function_state/hash_state'
require 'biz_actions/member_home/index_action'

class Member::HomeController < ApplicationController
  include Filter::MethodRegulation
  include Filter::MemberRegulation
  include Filter::UpdateSession
  include BizActions::MemberHome
  # レイアウト定義
  layout nil
  # フィルタ設定
  before_filter MethodRegulationFilter.new(:POST)
  before_filter MemberRegulationFilter.new
  around_filter UpdateSessionFilter.new
  
  # 会員ホーム表示
  def index
    @page_title = view_text('home.item_names.page_title')
    @biz_obj = IndexAction.new(self)
    @error_msg_hash = @biz_obj.error_msg_hash
    respond_to do |format|
      format.html {render :action=>'home', :layout=>'layout_2'}
    end
  end
  
  # 機能状態生成
  def create_function_state(cntr_path, new_trans_no, prev_trans_no, sept_flg)
    return FunctionState::HashState.new(cntr_path, new_trans_no, prev_trans_no, sept_flg)
  end
end
