# -*- coding: utf-8 -*-
###############################################################################
# 機能：全文検索
# クラス：コントローラー
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/02/09 Nakanohito
# 更新日:
###############################################################################
require 'filter/member_regulation/member_regulation_filter'
require 'filter/update_session/update_session_filter'
require 'biz_actions/search_fulltext/form_action'
require 'biz_actions/search_fulltext/quote_action'
require 'biz_actions/search_fulltext/comment_action'

class Search::FulltextController < ApplicationController
  include Filter::MemberRegulation
  include Filter::UpdateSession
  include BizActions::SearchFulltext
  # レイアウト定義
  layout nil
  # フィルタ設定
  before_filter :member_regulation
  around_filter :update_session
  
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
      format.html { render :action=>'form', :layout=>'layout_2' }
    end
  end
  
  # コメント検索
  def comment
    @page_title = view_text('form.item_names.page_title')
    @biz_obj = CommentAction.new(self)
    @biz_obj.search?
    @error_msg_hash = @biz_obj.error_msg_hash
    respond_to do |format|
      format.html { render :action=>'form', :layout=>'layout_2' }
    end
  end

  # 会員規制フィルタ
  def member_regulation
    # POSTの場合のみ適用
    if filter_exec? then
      MemberRegulationFilter.new.filter(self)
    end
  end
  
  # セッション更新フィルタ
  def update_session(&action)
    # POSTの場合のみ適用
    if filter_exec? then
      UpdateSessionFilter.new.filter(self, &action)
    else
      yield
    end
  end
  
  # フィルタ処理の実行判定
  def filter_exec?
    return flash[:redirect_flg] == true || request.request_method == 'POST'
  end
end
