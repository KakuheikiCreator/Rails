# -*- coding: utf-8 -*-
###############################################################################
# 機能：スケジュール一覧
# クラス：コントローラー
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/08/01 Nakanohito
# 更新日:
###############################################################################
require 'filter/method_regulation/method_regulation_filter'
require 'filter/update_session/update_session_filter'
require 'biz_actions/schedule_list/list_action'
require 'biz_actions/schedule_list/create_action'
require 'biz_actions/schedule_list/update_action'
require 'biz_actions/schedule_list/delete_action'
require 'biz_actions/schedule_list/notify_action'
require 'biz_helpers/schedule_list/list_helper'

class ScheduleList::ScheduleListController < ApplicationController
  include Filter::MethodRegulation
  include Filter::UpdateSession
  include BizActions::ScheduleList
  include BizHelpers::ScheduleList
  # フィルタ設定
  before_filter MethodRegulationFilter.new(:POST)
  around_filter UpdateSessionFilter.new

  #############################################################################
  # public定義
  #############################################################################
  public
  # スケジュール一覧画面表示
  def list
    @biz_obj = ListAction.new(self)
    @helper  = ListHelper.new(self)
    # ビュー変数宣言
    @err_hash = @biz_obj.error_msg_hash
    @system_id = @biz_obj.system_id
    @from_datetime = @biz_obj.from_datetime
    @to_datetime = @biz_obj.to_datetime
    @sort_item   = @biz_obj.sort_item
    @sort_order  = @biz_obj.sort_order
    @disp_counts = @biz_obj.disp_counts
    # スケジュールリスト
    @schedule_list = @biz_obj.search_list
    respond_to do |format|
      format.html # list.html.erb
    end
  end
  
  # スケジュール登録
  def create
    @biz_obj = CreateAction.new(self)
    @helper  = ListHelper.new(self)
    # データ保存
    @biz_obj.save_data?
    # ビュー変数宣言
    @err_hash = @biz_obj.error_msg_hash
    @system_id = @biz_obj.system_id
    @from_datetime = @biz_obj.from_datetime
    @to_datetime = @biz_obj.to_datetime
    @sort_item   = @biz_obj.sort_item
    @sort_order  = @biz_obj.sort_order
    @disp_counts = @biz_obj.disp_counts
    # スケジュールリスト
    @schedule_list = @biz_obj.schedule_list
    render :action=>'list' # list.html.erb
  end
  
  # スケジュール更新
  def update
    @biz_obj = UpdateAction.new(self)
    @helper  = ListHelper.new(self)
    # データ保存
    @biz_obj.update_data?
    # ビュー変数宣言
    @err_hash = @biz_obj.error_msg_hash
    @system_id = @biz_obj.system_id
    @from_datetime = @biz_obj.from_datetime
    @to_datetime = @biz_obj.to_datetime
    @sort_item   = @biz_obj.sort_item
    @sort_order  = @biz_obj.sort_order
    @disp_counts = @biz_obj.disp_counts
    # スケジュールリスト
    @schedule_list = @biz_obj.schedule_list
    render :action=>'list' # list.html.erb
  end
  
  # スケジュール削除
  def delete
    @biz_obj = DeleteAction.new(self)
    @helper  = ListHelper.new(self)
    # データ削除
    @biz_obj.delete_data?
    # ビュー変数宣言
    @err_hash = @biz_obj.error_msg_hash
    @system_id = @biz_obj.system_id
    @from_datetime = @biz_obj.from_datetime
    @to_datetime = @biz_obj.to_datetime
    @sort_item   = @biz_obj.sort_item
    @sort_order  = @biz_obj.sort_order
    @disp_counts = @biz_obj.disp_counts
    # スケジュールリスト
    @schedule_list = @biz_obj.schedule_list
    render :action=>'list' # list.html.erb
  end
  
  # スケジュール更新通知
  def notify
    @biz_obj = NotifyAction.new(self)
    @helper   = ListHelper.new(self)
    # 処理通知
    @biz_obj.notify?
    # ビュー変数宣言
    @err_hash = @biz_obj.error_msg_hash
    @system_id = @biz_obj.system_id
    @from_datetime = @biz_obj.from_datetime
    @to_datetime = @biz_obj.to_datetime
    @sort_item   = @biz_obj.sort_item
    @sort_order  = @biz_obj.sort_order
    @disp_counts = @biz_obj.disp_counts
    # スケジュールリスト
    @schedule_list = @biz_obj.schedule_list
    render :action=>'list' # list.html.erb
  end
end
