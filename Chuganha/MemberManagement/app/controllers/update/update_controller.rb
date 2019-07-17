# -*- coding: utf-8 -*-
###############################################################################
# 機能：会員情報更新
# クラス：コントローラー
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/12/10 Nakanohito
# 更新日:
###############################################################################
require 'filter/method_regulation/method_regulation_filter'
require 'filter/user_regulation/user_regulation_filter'
require 'filter/update_session/update_session_filter'
require 'biz_actions/update/form_action'
require 'biz_actions/update/confirmation_action'
require 'biz_actions/update/update_action'
require 'biz_actions/update/complete_action'
require 'biz_actions/update/miss_action'

class Update::UpdateController < ApplicationController
  include Filter::MethodRegulation
  include Filter::UserRegulation
  include Filter::UpdateSession
  include BizActions::Update
  # レイアウト未指定
  layout nil
  # フィルタ設定
  before_filter MethodRegulationFilter.new(:POST), :except=>['complete', 'miss']
  before_filter UserRegulationFilter.new, :except=>['complete', 'miss']
  around_filter UpdateSessionFilter.new, :except=>['complete', 'miss']
  
  # 会員情報更新フォーム表示
  def form
    @biz_obj = FormAction.new(self)
    @page_title = view_text('form.item_names.page_titile')
    @page_title_image = 'update/update_title.jpg'
    @err_hash = @biz_obj.error_msg_hash
    respond_to do |format|
      format.html {
        render :action=>'form', :layout=>'layout_2'
      }
    end
  end
  
  # 会員情報確認
  def confirmation
    @biz_obj = ConfirmationAction.new(self)
    @page_title = view_text('confirmation.item_names.page_titile')
    @page_title_image = 'update/update_title.jpg'
    @err_hash = @biz_obj.error_msg_hash
    respond_to do |format|
      format.html {
        # 戻る判定
        if @biz_obj.valid? then
          render :action=>'confirmation', :layout=>'layout_2'
        else
          render :action=>'form', :layout=>'layout_2'
        end
      }
    end
  end
  
  # 会員情報更新
  def update
    @biz_obj = UpdateAction.new(self)
    @page_title = view_text('update.item_names.page_titile')
    @page_title_image = 'update/update_title.jpg'
    @err_hash = @biz_obj.error_msg_hash
    respond_to do |format|
      format.html {
        # 表示判定
        if @biz_obj.correct? then
          render :action=>'form', :layout=>'layout_2'
        elsif @biz_obj.update? then
          render :action=>'update', :layout=>'layout_2'
        else
          render :action=>'form', :layout=>'layout_2'
        end
      }
    end
  end
  
  # 更新完了メッセージ表示
  def complete
    @biz_obj = CompleteAction.new(self)
    result_flg = @biz_obj.completing?
    @page_title = view_text('complete.item_names.page_titile') + result_flg.to_s
    respond_to do |format|
      format.html {render :action=>'complete', :layout=>'layout_mbl'}
    end
  end
  
  # 誤更新データ削除処理
  def miss
    @biz_obj = MissAction.new(self)
    result_flg = @biz_obj.stop_account?
    @page_title = view_text('miss.item_names.page_titile') + result_flg.to_s
    respond_to do |format|
      format.html {render :action=>'miss', :layout=>'layout_mbl'}
    end
  end
  
  #############################################################################
  # protected定義
  #############################################################################
  protected
  # 会員情報更新フォームに遷移
  def return_to_form
    flash[:redirect_flg] = true
    flash[:params] = create_scr_trans_params(self, TRANS_PTN_NOW)
    redirect_to(:controller=>"update/update", :action=>"form")
  end
  
end
