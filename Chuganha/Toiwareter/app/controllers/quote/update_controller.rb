# -*- coding: utf-8 -*-
###############################################################################
# 機能：引用更新
# クラス：コントローラー
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/02/25 Nakanohito
# 更新日:
###############################################################################
require 'filter/method_regulation/method_regulation_filter'
require 'filter/member_regulation/member_regulation_filter'
require 'filter/update_session/update_session_filter'
require 'biz_actions/quote_update/form_action'
require 'biz_actions/quote_update/check_action'
require 'biz_actions/quote_update/update_action'

class Quote::UpdateController < ApplicationController
  include Filter::MethodRegulation
  include Filter::MemberRegulation
  include Filter::UpdateSession
  include BizActions::QuoteUpdate
  # レイアウト定義
  layout nil
  # フィルタ設定
  before_filter MethodRegulationFilter.new(:POST)
  before_filter MemberRegulationFilter.new
  around_filter UpdateSessionFilter.new
  
  # 更新フォーム
  def form
    @page_title = view_text('form.item_names.page_title')
    @biz_obj = FormAction.new(self)
    @biz_obj.search?
    @source_obj = @biz_obj.source_obj
    @error_msg_hash = @biz_obj.error_msg_hash
    respond_to do |format|
      format.html {
        if @biz_obj.status == FormAction::STATUS_OK then
          render :action=>'form', :layout=>'layout_2'
        elsif @biz_obj.status == FormAction::STATUS_AUTH_ERROR then
          render_403
        else
          render_404
        end        
      }
    end
  end

  # コメント削除チェック
  def check
    @biz_obj = CheckAction.new(self)
    @biz_obj.valid?
    @source_obj = @biz_obj.source_obj
    @error_msg_hash = @biz_obj.error_msg_hash
    respond_to do |format|
      format.html {
        if @biz_obj.status == CheckAction::STATUS_OK then
          @page_title = view_text('check.item_names.page_title')
          render :action=>'check', :layout=>'layout_2'
        elsif @biz_obj.status == CheckAction::STATUS_AUTH_ERROR then
          render_403
        elsif @biz_obj.status == CheckAction::STATUS_QUOTE_ERROR then
          @page_title = view_text('form.item_names.page_title')
          render :action=>'form', :layout=>'layout_2'
        else
          render_404
        end
      }
    end
  end

  # コメント更新
  def update
    @biz_obj = UpdateAction.new(self)
    @biz_obj.update?
    @source_obj = @biz_obj.source_obj
    @error_msg_hash = @biz_obj.error_msg_hash
    respond_to do |format|
      format.html {
        if @biz_obj.status == UpdateAction::STATUS_OK then
          redirect_to_quote(@biz_obj.quote_id)
        elsif @biz_obj.status == UpdateAction::STATUS_AUTH_ERROR then
          render_403
        elsif @biz_obj.status == UpdateAction::STATUS_QUOTE_ERROR then
          @page_title = view_text('form.item_names.page_title')
          render :action=>'form', :layout=>'layout_2'
        else
          render_404
        end
      }
    end
  end
end
