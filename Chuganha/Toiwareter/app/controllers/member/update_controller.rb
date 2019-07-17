# -*- coding: utf-8 -*-
###############################################################################
# 機能：会員更新
# クラス：コントローラー
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/01/20 Nakanohito
# 更新日:
###############################################################################
require 'filter/method_regulation/method_regulation_filter'
require 'filter/member_regulation/member_regulation_filter'
require 'filter/update_session/update_session_filter'
require 'function_state/hash_state'
require 'biz_actions/member_update/form_action'
require 'biz_actions/member_update/check_action'
require 'biz_actions/member_update/update_action'

class Member::UpdateController < ApplicationController
  include Filter::MethodRegulation
  include Filter::MemberRegulation
  include Filter::UpdateSession
  include BizActions::MemberUpdate
  # レイアウト定義
  layout nil
  # フィルタ設定
  before_filter MethodRegulationFilter.new(:POST)
  before_filter MemberRegulationFilter.new
  around_filter UpdateSessionFilter.new

  # 会員情報更新フォーム表示
  def form
    @page_title = view_text('form.item_names.page_title')
    @biz_obj = FormAction.new(self)
    @error_msg_hash = @biz_obj.error_msg_hash
    respond_to do |format|
      format.html {render :action=>'form', :layout=>'layout_2'}
    end
  end

  # 更新チェック処理
  def check
    @biz_obj = CheckAction.new(self)
    @error_msg_hash = @biz_obj.error_msg_hash
    valid_flg = @biz_obj.valid?
    respond_to do |format|
      format.html {
        if valid_flg then
          @page_title = view_text('form.item_names.page_title')
          render :action=>'check', :layout=>'layout_2'
        else
          @page_title = view_text('form.item_names.page_title')
          render :action=>'form', :layout=>'layout_2'
        end
      }
    end
  end
  
  # 更新処理
  def update
    @biz_obj = UpdateAction.new(self)
    @error_msg_hash = @biz_obj.error_msg_hash
    update_flg = @biz_obj.update?
    respond_to do |format|
      format.html {
        if update_flg then
          redirect_to_home(@biz_obj.member_id)
        else
          @page_title = view_text('form.item_names.page_title')
          render :action=>'form', :layout=>'layout_2'
        end
      }
    end
  end
  
  # 機能状態生成
  def create_function_state(cntr_path, new_trans_no, prev_trans_no, sept_flg)
    return FunctionState::HashState.new(cntr_path, new_trans_no, prev_trans_no, sept_flg)
  end
end
