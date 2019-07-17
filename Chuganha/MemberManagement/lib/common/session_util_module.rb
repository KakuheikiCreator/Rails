# -*- coding: utf-8 -*-
###############################################################################
# セッションユーティリティモジュール
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/01/31 Nakanohito
# 更新日:
###############################################################################
require 'function_state/function_state'
require 'function_state/function_state_hash'

module Common
  module SessionUtilModule
    ###########################################################################
    # public定義
    ###########################################################################
    public
    # 定数（パターン）
    TRANS_PTN_NEW  = '1' # 新規起動
    TRANS_PTN_OTH  = '2' # 別画面起動
    TRANS_PTN_NOW  = '3' # 現在機能内遷移
    TRANS_PTN_BACK = '4' # 直前遷移
    TRANS_PTN_REST = '5' # 復元遷移
    TRANS_PTN_REP  = '6' # 置換遷移
    TRANS_PTN_CLH  = '7' # 履歴クリア後新規起動
    TRANS_PTN_CLR  = '8' # 全状態クリア後新規起動
    TRANS_PTN_HCL  = '9' # 履歴クリア
    # その他
    TOKEN_SIZE     = 40  # 同期トークンサイズ
    
    # 画面遷移パラメータハッシュ生成
    def create_scr_trans_params(controller, trans_ptn, restored_trans_no=nil)
      state = controller.session[:function_state]
      params = {:screen_transition_pattern=>trans_ptn,
                :function_transition_no=>state.func_tran_no.to_s,
                :synchronous_token=>state.sync_tkn}
      params[:restored_transition_no] = restored_trans_no.to_s unless restored_trans_no.nil?
      return params
    end
    module_function :create_scr_trans_params
    
    # 機能状態初期化処理
    def function_state_init?(controller)
      # セッションのリセット
      controller.reset_session
      # 機能状態ハッシュ生成
      state_hash = FunctionState::FunctionStateHash.new
      session = controller.session
      session[:function_state_hash] = state_hash
      # 機能状態生成
      state = state_hash.new_state(controller, nil, true)
      if state.nil? then
        controller.reset_session
        return false
      end
      session[:function_state] = state
      return true
    end
    module_function :function_state_init?
  end
end