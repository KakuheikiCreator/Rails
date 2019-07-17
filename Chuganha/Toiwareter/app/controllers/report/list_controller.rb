# -*- coding: utf-8 -*-
###############################################################################
# 機能：コメント通報リスト
# クラス：コントローラー
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/02/27 Nakanohito
# 更新日:
###############################################################################
require 'filter/method_regulation/method_regulation_filter'
require 'filter/member_regulation/member_regulation_filter'
require 'filter/update_session/update_session_filter'
require 'biz_actions/report_list/list_action'
require 'biz_actions/report_list/search_action'
require 'biz_actions/report_list/prev_action'
require 'biz_actions/report_list/next_action'

class Report::ListController < ApplicationController
  include Filter::MethodRegulation
  include Filter::MemberRegulation
  include Filter::UpdateSession
  include BizActions::ReportList
  # レイアウト定義
  layout nil
  # フィルタ設定
  before_filter MethodRegulationFilter.new(:POST)
  before_filter MemberRegulationFilter.new(:all=>true)
  around_filter UpdateSessionFilter.new
  
  # コメント通報リスト表示
  def list
    @page_title = view_text('list.item_names.page_title')
    @biz_obj = ListAction.new(self)
    @error_msg_hash = @biz_obj.error_msg_hash
    respond_to do |format|
      format.html {render :action=>'list', :layout=>'layout_3'}
    end
  end
  
  # 通報リスト検索
  def search
    @page_title = view_text('list.item_names.page_title')
    @biz_obj = SearchAction.new(self)
    @biz_obj.search_list?
    @error_msg_hash = @biz_obj.error_msg_hash
    respond_to do |format|
      format.html {render :action=>'list', :layout=>'layout_3'}
    end
  end
  
  # 前ページ検索
  def prev
    @page_title = view_text('list.item_names.page_title')
    @biz_obj = PrevAction.new(self)
    @biz_obj.search_list?
    @error_msg_hash = @biz_obj.error_msg_hash
    respond_to do |format|
      format.html {render :action=>'list', :layout=>'layout_3'}
    end
  end
  
  # 次ページ検索
  def next
    @page_title = view_text('list.item_names.page_title')
    @biz_obj = NextAction.new(self)
    @biz_obj.search_list?
    @error_msg_hash = @biz_obj.error_msg_hash
    respond_to do |format|
      format.html {render :action=>'list', :layout=>'layout_3'}
    end
  end
end
