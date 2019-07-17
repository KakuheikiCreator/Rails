# -*- coding: utf-8 -*-
###############################################################################
# 機能：コメント投稿
# クラス：コントローラー
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/02/11 Nakanohito
# 更新日:
###############################################################################
require 'filter/method_regulation/method_regulation_filter'
require 'filter/member_regulation/member_regulation_filter'
require 'filter/update_session/update_session_filter'
require 'biz_actions/comment_post/check_action'
require 'biz_actions/comment_post/create_action'

class Comment::PostController < ApplicationController
  include Filter::MethodRegulation
  include Filter::MemberRegulation
  include Filter::UpdateSession
  include BizActions::CommentPost
  # レイアウト定義
  layout nil
  # フィルタ設定
  before_filter MethodRegulationFilter.new(:POST)
  before_filter MemberRegulationFilter.new
  before_filter :auth_regulation
  around_filter UpdateSessionFilter.new

  # 引用情報チェック
  def check
    @page_title = view_text('check.item_names.page_title')
    @biz_obj = CheckAction.new(self)
    @biz_obj.check?
    @source_obj = @biz_obj.source_ent
    @error_msg_hash = @biz_obj.error_msg_hash
    respond_to do |format|
      format.html {
        case @biz_obj.result_status
        when CheckAction::STATUS_OK then
          render :action=>'check', :layout=>'layout_2'
        when CheckAction::STATUS_QUOTE_ERROR then
          render_404
        else
          redirect_to_quote(@biz_obj.quote_id,
          {:comment=>@biz_obj.comment, :comment_err_msg=>@error_msg_hash[:comment]})
        end
      }
    end
  end

  # 引用情報チェック
  def create
    @biz_obj = CreateAction.new(self)
    @biz_obj.create?
    @source_obj = @biz_obj.source_ent
    @error_msg_hash = @biz_obj.error_msg_hash
    respond_to do |format|
      format.html {
        case @biz_obj.result_status
        when CreateAction::STATUS_OK then
          redirect_to_quote(@biz_obj.quote_id)
        when CreateAction::STATUS_QUOTE_ERROR then
          render_404
        else
          redirect_to_quote(@biz_obj.quote_id,
          {:comment=>@biz_obj.comment, :comment_err_msg=>@error_msg_hash[:comment]})
        end
      }
    end
  end

  # 会員権限規制フィルタ
  def auth_regulation
    unless session[:authority_hash][:comment_post] then
      # 権限エラー
      logger.warn('Member authority Error!!! MemberID:' + session[:member_id].to_s)
      render_403
    end
  end
end
