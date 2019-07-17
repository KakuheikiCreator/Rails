# -*- coding: utf-8 -*-
###############################################################################
# 機能：会員一覧
# クラス：コントローラー
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/12/16 Nakanohito
# 更新日:
###############################################################################
require 'filter/method_regulation/method_regulation_filter'
require 'filter/user_regulation/user_regulation_filter'
require 'filter/update_session/update_session_filter'
require 'biz_actions/list/form_action'
require 'biz_actions/list/search_action'

class List::ListController < ApplicationController
  include Filter::MethodRegulation
  include Filter::UserRegulation
  include Filter::UpdateSession
  include BizActions::List
  include BizCommon
  # レイアウト未指定
  layout nil
  # フィルタ設定
  before_filter MethodRegulationFilter.new(:POST)
  before_filter UserRegulationFilter.new({:form=>true, :search=>true})
  around_filter UpdateSessionFilter.new

  # 会員検索リストフォーム表示
  def form
    @biz_obj = FormAction.new(self)
    @page_title = view_text('list.item_names.page_titile')
    @page_title_image = 'list/list_title.jpg'
    @err_hash = @biz_obj.error_msg_hash
    respond_to do |format|
      format.html {render :action=>'list', :layout=>'layout_3'}
    end
  end

  # 会員検索リスト検索
  def search
    @biz_obj = SearchAction.new(self)
    @biz_obj.search_list?
    @page_title = view_text('list.item_names.page_titile')
    @page_title_image = 'list/list_title.jpg'
    @err_hash = @biz_obj.error_msg_hash
Rails.logger.debug('@err_hash:' + @err_hash.to_s)
    respond_to do |format|
      format.html {render :action=>'list', :layout=>'layout_3'}
    end
  end
end
