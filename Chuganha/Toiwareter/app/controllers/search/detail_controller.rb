# -*- coding: utf-8 -*-
###############################################################################
# 機能：詳細検索
# クラス：コントローラー
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/03/03 Nakanohito
# 更新日:
###############################################################################
require 'filter/method_regulation/method_regulation_filter'
require 'filter/member_regulation/member_regulation_filter'
require 'filter/update_session/update_session_filter'
require 'biz_actions/search_detail/form_action'
require 'biz_actions/search_detail/quote_action'
require 'biz_actions/search_detail/source_action'
require 'biz_actions/search_detail/comment_action'

class Search::DetailController < ApplicationController
  include Filter::MethodRegulation
  include Filter::MemberRegulation
  include Filter::UpdateSession
  include BizActions::SearchDetail
  # レイアウト定義
  layout nil
  # フィルタ設定
  before_filter MethodRegulationFilter.new(:POST)
  before_filter MemberRegulationFilter.new
  around_filter UpdateSessionFilter.new
  
  # 検索フォーム表示
  def form
    @page_title = view_text('form.item_names.page_title')
    @biz_obj = FormAction.new(self)
    @error_msg_hash = @biz_obj.error_msg_hash
    respond_to do |format|
      format.html {render :action=>'form', :layout=>'layout_2'}
    end
  end
  
  # 引用検索
  def quote
    @page_title = view_text('form.item_names.page_title')
    @biz_obj = QuoteAction.new(self)
    @biz_obj.search?
    @error_msg_hash = @biz_obj.error_msg_hash
    respond_to do |format|
      format.html {render :action=>'form', :layout=>'layout_2'}
    end
  end
  
  # 出典検索
  def source
    @page_title = view_text('form.item_names.page_title')
    @biz_obj = SourceAction.new(self)
    @biz_obj.search?
    @error_msg_hash = @biz_obj.error_msg_hash
    respond_to do |format|
      format.html {render :action=>'form', :layout=>'layout_2'}
    end
  end
  
  # コメント検索
  def comment
    @page_title = view_text('form.item_names.page_title')
    @biz_obj = CommentAction.new(self)
    @biz_obj.search?
    @error_msg_hash = @biz_obj.error_msg_hash
    respond_to do |format|
      format.html {render :action=>'form', :layout=>'layout_2'}
    end
  end
  
end
