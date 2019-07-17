# -*- coding: utf-8 -*-
###############################################################################
# 機能：会員リスト
# クラス：コントローラー
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/01/15 Nakanohito
# 更新日:
###############################################################################
require 'filter/method_regulation/method_regulation_filter'
require 'filter/member_regulation/member_regulation_filter'
require 'filter/update_session/update_session_filter'
require 'biz_actions/member_list/list_action'
require 'biz_actions/member_list/search_action'

class Member::ListController < ApplicationController
  include Filter::MethodRegulation
  include Filter::MemberRegulation
  include Filter::UpdateSession
  include BizActions::MemberList
  # レイアウト定義
  layout nil
  # フィルタ設定
  before_filter MethodRegulationFilter.new(:POST), :except=>['list']
  before_filter MemberRegulationFilter.new(:all=>true), :except=>['list']
  around_filter UpdateSessionFilter.new, :except=>['list']
#  before_filter MethodRegulationFilter.new(:POST)
#  before_filter MemberRegulationFilter.new(:all=>true)
#  around_filter UpdateSessionFilter.new
  
  # 会員リスト表示
  def list
    # セッション初期化
    SessionUtilModule.function_state_init?(self)
    session[:member_id] = 'MBR0000000'
    session[:authority_cls] = Authority::AUTHORITY_CLS_ADMIN
    session[:nickname] = '中の人'
    session[:authority_hash] = {:quote_post=>true, :quote_update=>true, :quote_delete=>true,
                                :comment_post=>true, :comment_report=>true}
    @page_title = view_text('list.item_names.page_title')
    @biz_obj = ListAction.new(self)
    @error_msg_hash = @biz_obj.error_msg_hash
    respond_to do |format|
      format.html {render :action=>'list', :layout=>'layout_3'}
    end
  end
  
  # 会員検索
  def search
    @page_title = view_text('list.item_names.page_title')
    @biz_obj = SearchAction.new(self)
    @biz_obj.search_list?
    @error_msg_hash = @biz_obj.error_msg_hash
    respond_to do |format|
      format.html {render :action=>'list', :layout=>'layout_3'}
    end
  end
end
