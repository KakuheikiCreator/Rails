# -*- coding: utf-8 -*-
###############################################################################
# 機能：規制リファラー一覧
# クラス：コントローラー
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/07/31 Nakanohito
# 更新日:
###############################################################################
require 'filter/method_regulation/method_regulation_filter'
require 'filter/update_session/update_session_filter'
require 'biz_actions/regulation_referrer_list/list_action'
require 'biz_actions/regulation_referrer_list/create_action'
require 'biz_actions/regulation_referrer_list/delete_action'
require 'biz_actions/regulation_referrer_list/notify_action'
require 'biz_helpers/regulation_referrer_list/list_helper'

class RegulationReferrerList::RegulationReferrerListController < ApplicationController
  include Filter::MethodRegulation
  include Filter::UpdateSession
  include BizActions::RegulationReferrerList
  include BizHelpers::RegulationReferrerList
  # フィルタ設定
  before_filter MethodRegulationFilter.new(:POST)
  around_filter UpdateSessionFilter.new

  #############################################################################
  # public定義
  #############################################################################
  public
  # 規制リファラー一覧画面表示
  def list
    list_action = ListAction.new(self)
    # ビュー変数宣言
    @helper   = ListHelper.new(self)
    @err_hash = list_action.error_msg_hash
    @reg_referrer  = list_action.reg_referrer
    @sort_item   = list_action.sort_item
    @sort_order  = list_action.sort_order
    @disp_counts = list_action.disp_counts
    @reg_referrer_list = list_action.search_list
    respond_to do |format|
      format.html # list.html.erb
    end
  end
  
  # 規制クッキー登録
  def create
    create_action = CreateAction.new(self)
    # データ保存
    create_action.save_data?
    # ビュー変数宣言
    @helper   = ListHelper.new(self)
    @err_hash = create_action.error_msg_hash
    @reg_referrer  = create_action.reg_referrer
    @sort_item   = create_action.sort_item
    @sort_order  = create_action.sort_order
    @disp_counts = create_action.disp_counts
    @reg_referrer_list = create_action.reg_referrer_list
    render :action=>'list' # list.html.erb
  end
  
  # 規制リファラー削除
  def delete
    delete_action = DeleteAction.new(self)
    # データ削除
    delete_action.delete_data?
    # ビュー変数宣言
    @helper   = ListHelper.new(self)
    @err_hash = delete_action.error_msg_hash
    @reg_referrer  = delete_action.reg_referrer
    @sort_item   = delete_action.sort_item
    @sort_order  = delete_action.sort_order
    @disp_counts = delete_action.disp_counts
    @reg_referrer_list = delete_action.reg_referrer_list
    render :action=>'list' # list.html.erb
  end
  
  # 規制リファラー更新通知
  def notify
    notify_action = NotifyAction.new(self)
    # 処理通知
    notify_action.notify?
    # ビュー変数宣言
    @helper   = ListHelper.new(self)
    @err_hash = notify_action.error_msg_hash
    @reg_referrer  = notify_action.reg_referrer
    @sort_item   = notify_action.sort_item
    @sort_order  = notify_action.sort_order
    @disp_counts = notify_action.disp_counts
    @reg_referrer_list = notify_action.reg_referrer_list
    render :action=>'list' # list.html.erb
  end
end
