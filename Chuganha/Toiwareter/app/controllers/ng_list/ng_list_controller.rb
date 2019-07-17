# -*- coding: utf-8 -*-
###############################################################################
# 機能：NGワードリスト
# クラス：コントローラー
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/01/14 Nakanohito
# 更新日:
###############################################################################
require 'filter/method_regulation/method_regulation_filter'
require 'filter/member_regulation/member_regulation_filter'
require 'filter/update_session/update_session_filter'
require 'biz_actions/ng_list/list_action'
require 'biz_actions/ng_list/create_action'
require 'biz_actions/ng_list/delete_action'

class NgList::NgListController < ApplicationController
  include Filter::MethodRegulation
  include Filter::MemberRegulation
  include Filter::UpdateSession
  include BizActions::NgList
  # レイアウト定義
  layout nil
  # フィルタ設定
  before_filter MethodRegulationFilter.new(:POST)
  before_filter MemberRegulationFilter.new(:all=>true)
  around_filter UpdateSessionFilter.new
  
  # NGワードリスト表示
  def list
    @page_title = view_text('list.item_names.page_title')
    @biz_obj = ListAction.new(self)
    @error_msg_hash = @biz_obj.error_msg_hash
    respond_to do |format|
      format.html {render :action=>'list', :layout=>'layout_2'}
    end
  end
  
  # NGワード登録
  def create
    @page_title = view_text('list.item_names.page_title')
    @biz_obj = CreateAction.new(self)
    @biz_obj.create?
    @error_msg_hash = @biz_obj.error_msg_hash
    respond_to do |format|
      format.html {render :action=>'list', :layout=>'layout_2'}
    end
  end
  
  # NGワード削除
  def delete
    @page_title = view_text('list.item_names.page_title')
    @biz_obj = DeleteAction.new(self)
    @biz_obj.delete?
    @error_msg_hash = @biz_obj.error_msg_hash
    respond_to do |format|
      format.html {render :action=>'list', :layout=>'layout_2'}
    end
  end
end
