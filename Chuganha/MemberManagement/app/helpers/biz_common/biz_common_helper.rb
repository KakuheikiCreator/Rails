# -*- coding: utf-8 -*-
###############################################################################
# クラス：業務共通ヘルパー
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2013/01/04 Nakanohito
# 更新日:
###############################################################################
require 'common/session_util_module'
require 'data_cache/generic_code_cache'

module BizCommon::BizCommonHelper
  # ログイン済み判定
  def user_login?
    return !session[:user_id].nil?
  end
  
  # 管理者判定
  def user_admin?
    return Authority::AUTHORITY_CLS_ADMIN == session[:authority_cls]
  end
end
