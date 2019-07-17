# -*- coding: utf-8 -*-
###############################################################################
# 機能：新規会員登録
# クラス：コントローラー
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/01/08 Nakanohito
# 更新日:
###############################################################################
require 'filter/method_regulation/method_regulation_filter'
require 'filter/update_session/update_session_filter'
require 'function_state/hash_state'
require 'biz_actions/admission/form_action'
require 'biz_actions/admission/register_action'

class Admission::AdmissionController < ApplicationController
  include Filter::MethodRegulation
  include Filter::UpdateSession
  include BizActions::Admission
  # レイアウト定義
  layout nil
  # フィルタ設定
  before_filter MethodRegulationFilter.new(:POST)
  around_filter UpdateSessionFilter.new
  
  # ログインフォーム表示
  def form
    @page_title = view_text('form.item_names.page_title')
    @biz_obj = FormAction.new(self)
    @error_msg_hash = @biz_obj.error_msg_hash
    respond_to do |format|
      format.html {
        if @biz_obj.valid? then
          render :action=>'form', :layout=>'layout_1'
        else
          render_403
        end
      }
    end
  end
  
  # 会員登録処理
  def register
    @page_title = view_text('form.item_names.page_title')
    @biz_obj = RegisterAction.new(self)
    @error_msg_hash = @biz_obj.error_msg_hash
    respond_to do |format|
      format.html {
        if @biz_obj.registration? then
          redirect_to_home
        else
          render :action=>'form', :layout=>'layout_1'
        end
      }
    end
  end
  
  # 機能状態生成
  def create_function_state(cntr_path, new_trans_no, prev_trans_no, sept_flg)
    return FunctionState::HashState.new(cntr_path, new_trans_no, prev_trans_no, sept_flg)
  end
end
