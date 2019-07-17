# -*- coding: utf-8 -*-
###############################################################################
# 機能：会員情報表示
# クラス：コントローラー
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/01/23 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/member_view/index_action'

class Member::ViewController < ApplicationController
  include BizActions::MemberView
  # レイアウト定義
  layout nil
  
  # 会員情報表示
  def index
    @page_title = view_text('index.item_names.page_title')
    @biz_obj = IndexAction.new(self)
    @error_msg_hash = @biz_obj.error_msg_hash
    respond_to do |format|
      format.html {render :action=>'index', :layout=>'layout_2'}
    end
  end
end
