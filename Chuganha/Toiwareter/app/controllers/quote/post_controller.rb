# -*- coding: utf-8 -*-
###############################################################################
# 機能：引用投稿
# クラス：コントローラー
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/01/23 Nakanohito
# 更新日:
###############################################################################
require 'filter/method_regulation/method_regulation_filter'
require 'filter/member_regulation/member_regulation_filter'
require 'filter/update_session/update_session_filter'
require 'biz_actions/quote_post/form_action'
require 'biz_actions/quote_post/source_action'
require 'biz_actions/quote_post/check_action'
require 'biz_actions/quote_post/create_action'

class Quote::PostController < ApplicationController
  include Filter::MethodRegulation
  include Filter::MemberRegulation
  include Filter::UpdateSession
  include BizActions::QuotePost
  # レイアウト定義
  layout nil
  # フィルタ設定
  before_filter MethodRegulationFilter.new(:POST)
  before_filter MemberRegulationFilter.new
  before_filter :auth_regulation
  around_filter UpdateSessionFilter.new
  
  # 投稿フォーム表示
  def form
    @page_title = view_text('form.item_names.page_title')
    @biz_obj = FormAction.new(self)
    @source_obj = @biz_obj.source_obj
    @error_msg_hash = @biz_obj.error_msg_hash
    respond_to do |format|
      format.html {render :action=>'form', :layout=>'layout_2'}
    end
  end
  
  # 出所情報フォーム表示
  def source
    @biz_obj = SourceAction.new(self)
    @source_obj = @biz_obj.source_obj
    @error_msg_hash = @biz_obj.error_msg_hash
    respond_to do |format|
      format.html {
        if @biz_obj.valid? then
          render :partial=>'partials/source_form/' + @source_obj.form_name
        else
          render_404
        end        
      }
    end
  end
  
  # 引用情報チェック
  def check
    @page_title = view_text('check.item_names.page_title')
    @biz_obj = CheckAction.new(self)
    valid_flg = @biz_obj.valid?
    @source_obj = @biz_obj.source_obj
    @error_msg_hash = @biz_obj.error_msg_hash
    respond_to do |format|
      format.html {
        if valid_flg then
          render :action=>'check', :layout=>'layout_2'
        else
          render :action=>'form', :layout=>'layout_2'
        end
      }
    end
  end
  
  # 引用情報生成
  def create
    @page_title = view_text('form.item_names.page_title')
    @biz_obj = CreateAction.new(self)
    create_flg = @biz_obj.create?
    @source_obj = @biz_obj.source_obj
    @error_msg_hash = @biz_obj.error_msg_hash
    respond_to do |format|
      format.html {
        if create_flg then
          redirect_to_quote(@biz_obj.quote_id)
        else
          render :action=>'form', :layout=>'layout_2'
        end
      }
    end
  end

  # 会員権限規制フィルタ
  def auth_regulation
    unless session[:authority_hash][:quote_post] then
      # 権限エラー
      logger.warn('Member authority Error!!! MemberID:' + session[:member_id].to_s)
      render_403
    end
  end
end
