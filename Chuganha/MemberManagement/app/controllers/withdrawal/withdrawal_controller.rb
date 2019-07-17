# -*- coding: utf-8 -*-
###############################################################################
# 機能：退会処理
# クラス：コントローラー
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/12/30 Nakanohito
# 更新日:
###############################################################################
require 'filter/method_regulation/method_regulation_filter'
require 'filter/user_regulation/user_regulation_filter'
require 'filter/update_session/update_session_filter'
require 'function_state/hash_state'
require 'biz_actions/withdrawal/form_action'
require 'biz_actions/withdrawal/confirmation_action'
require 'biz_actions/withdrawal/withdrawal_action'


class Withdrawal::WithdrawalController < ApplicationController
  include Filter::MethodRegulation
  include Filter::UserRegulation
  include Filter::UpdateSession
  include BizActions::Withdrawal
  # レイアウト未指定
  layout nil
  # フィルタ設定
  before_filter MethodRegulationFilter.new(:POST), :except=>['complete', 'miss']
  before_filter UserRegulationFilter.new, :except=>['complete', 'miss']
  around_filter UpdateSessionFilter.new, :except=>['complete', 'miss']
  
  #############################################################################
  # publicメソッド定義
  #############################################################################
  public
  # 退会フォーム表示
  def form
    @biz_obj = FormAction.new(self)
    @page_title = view_text('form.item_names.page_titile')
    @page_title_image = 'withdrawal/withdrawal_title.jpg'
    @error_hash = @biz_obj.error_msg_hash
    respond_to do |format|
      format.html {render :action=>'form', :layout=>'layout_2'}
    end
  end
  
  # 退会確認フォーム表示
  def confirmation
    @biz_obj = ConfirmationAction.new(self)
    @page_title = view_text('form.item_names.page_titile')
    @page_title_image = 'withdrawal/withdrawal_title.jpg'
    @error_hash = @biz_obj.error_msg_hash
    respond_to do |format|
      format.html {
        if @biz_obj.valid? then
          render :action=>'confirmation', :layout=>'layout_2'
        else
          render :action=>'form', :layout=>'layout_2'
        end
      }
    end
  end
  
  # 退会処理
  def withdrawal
    @biz_obj = WithdrawalAction.new(self)
    @page_title = view_text('form.item_names.page_titile')
    @page_title_image = 'withdrawal/withdrawal_title.jpg'
    @error_hash = @biz_obj.error_msg_hash
    respond_to do |format|
      format.html {
        if @biz_obj.withdrawal? then
          render :action=>'withdrawal', :layout=>'layout_2'
        else
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
