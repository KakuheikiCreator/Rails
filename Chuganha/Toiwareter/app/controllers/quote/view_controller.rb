# -*- coding: utf-8 -*-
###############################################################################
# 機能：引用表示
# クラス：コントローラー
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/02/08 Nakanohito
# 更新日:
###############################################################################
require 'filter/member_regulation/member_regulation_filter'
require 'filter/update_session/update_session_filter'
require 'biz_actions/quote_view/index_action'

class Quote::ViewController < ApplicationController
  include Filter::MemberRegulation
  include Filter::UpdateSession
  include BizActions::QuoteView
  # レイアウト定義
  layout nil
  # フィルタ設定
  before_filter :member_regulation
  around_filter :update_session
  
  # 引用文表示
  def index
    @page_title = view_text('index.item_names.page_title')
    @biz_obj = IndexAction.new(self)
    result_flg = @biz_obj.search?
    @source_obj = @biz_obj.source_ent
    @error_msg_hash = @biz_obj.error_msg_hash
    respond_to do |format|
      format.html {
        if result_flg then
          render :action=>'index', :layout=>'layout_2'
        else
          render_404
        end
      }
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
