# -*- coding: utf-8 -*-
###############################################################################
# 機能：アクセス集計
# クラス：コントローラー
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/09/19 Nakanohito
# 更新日:
###############################################################################
require 'filter/method_regulation/method_regulation_filter'
require 'filter/update_session/update_session_filter'
require 'biz_actions/access_total/totalization_action'
require 'biz_actions/access_total/function_action'
require 'biz_actions/access_total/browser_version_action'
require 'biz_helpers/access_total/totalization_helper'

class AccessTotal::AccessTotalController < ApplicationController
  include Filter::MethodRegulation
  include Filter::UpdateSession
  include BizActions::AccessTotal
  include BizHelpers::AccessTotal
  # フィルタ設定
  before_filter MethodRegulationFilter.new(:POST)
  around_filter UpdateSessionFilter.new
  
  #############################################################################
  # public定義
  #############################################################################
  public
  # フォーム表示
  def form
    @biz_obj = TotalizationAction.new(self)
    @helper  = TotalizationHelper.new(self)
    @err_hash = @biz_obj.error_msg_hash
    @date_list = []
    @graph_data = []
    render :action=>'totalization' # totalization.html.erb
  end
  
  # 集計処理
  def totalization
    @biz_obj = TotalizationAction.new(self)
    @helper  = TotalizationHelper.new(self)
    @biz_obj.totalization
    @err_hash = @biz_obj.error_msg_hash
    @date_list = @biz_obj.date_list
    @graph_data = @biz_obj.graph_data
    respond_to do |format|
      format.html # totalization.html.erb
    end
  end
  
  # 機能検索処理
  def function
    @biz_obj = FunctionAction.new(self)
    render :text=>@biz_obj.options_string
  end
  
  # ブラウザバージョン検索処理
  def browser_version
    @biz_obj = BrowserVersionAction.new(self)
    render :text=>@biz_obj.options_string
  end
end
