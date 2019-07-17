# -*- coding: utf-8 -*-
###############################################################################
# 機能：コメント削除
# クラス：コントローラー
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/02/12 Nakanohito
# 更新日:
###############################################################################
require 'filter/method_regulation/method_regulation_filter'
require 'filter/member_regulation/member_regulation_filter'
require 'filter/update_session/update_session_filter'
require 'biz_actions/delete_comment/form_action'
require 'biz_actions/delete_comment/check_action'
require 'biz_actions/delete_comment/delete_action'

class Comment::DeleteController < ApplicationController
  include Filter::MethodRegulation
  include Filter::MemberRegulation
  include Filter::UpdateSession
  include BizActions::DeleteComment
  # レイアウト定義
  layout nil
  # フィルタ設定
  before_filter MethodRegulationFilter.new(:POST)
  before_filter MemberRegulationFilter.new
  around_filter UpdateSessionFilter.new

  # コメント削除フォーム表示
  def form
    @page_title = view_text('form.item_names.page_title')
    @biz_obj = FormAction.new(self)
    @biz_obj.valid?
    @source_obj = @biz_obj.source_ent
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
    @source_obj = @biz_obj.source_ent
    @error_msg_hash = @biz_obj.error_msg_hash
    respond_to do |format|
      format.html {
        if @biz_obj.status == CheckAction::STATUS_OK then
          @page_title = view_text('check.item_names.page_title')
          render :action=>'check', :layout=>'layout_2'
        elsif @biz_obj.status == CheckAction::STATUS_AUTH_ERROR then
          render_403
        elsif @biz_obj.status == CheckAction::STATUS_DELETE_ERROR then
          @page_title = view_text('form.item_names.page_title')
          render :action=>'form', :layout=>'layout_2'
        else
          render_404
        end
      }
    end
  end

  # コメント削除
  def delete
    @biz_obj = DeleteAction.new(self)
    @biz_obj.delete?
    @source_obj = @biz_obj.source_ent
    @error_msg_hash = @biz_obj.error_msg_hash
    respond_to do |format|
      format.html {
        if @biz_obj.status == DeleteAction::STATUS_OK then
          redirect_to_quote(@biz_obj.quote_ent.id)
        elsif @biz_obj.status == DeleteAction::STATUS_AUTH_ERROR then
          render_403
        elsif @biz_obj.status == DeleteAction::STATUS_QUOTE_DELETE then
          redirect_to_home
        elsif @biz_obj.status == DeleteAction::STATUS_DELETE_ERROR then
          @page_title = view_text('form.item_names.page_title')
          render :action=>'form', :layout=>'layout_2'
        else
          render_404
        end
      }
    end
  end
end
