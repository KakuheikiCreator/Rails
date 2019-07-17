# -*- coding: utf-8 -*-
###############################################################################
# ファンクショナルテストユーティリティクラス
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/06/16 Nakanohito
# 更新日:
###############################################################################
require 'common/session_util_module'
require 'function_state/function_state'
require 'function_state/function_state_hash'

module FunctionalTestUtil
  CHAR_SET_HANKAKU         = (' '..'~').to_a + ('｡'..'ﾟ').to_a    # 半角
  CHAR_SET_ZENKAKU         = ('あ'..'ん').to_a + ('ア'..'ン').to_a # 全角
  CHAR_SET_ALPHABETIC      = ('A'..'Z').to_a + ('a'..'z').to_a   # 英字
  CHAR_SET_NUMERIC         = ('0'..'9').to_a   # 数字
  CHAR_SET_ALPHANUMERIC    = ('A'..'Z').to_a + ('a'..'z').to_a + ('0'..'9').to_a # 正規表現（英数字）
  CHAR_SET_YOMIGANA        = ('ア'..'ヴ').to_a + ['・', '＝', 'ー'] # ヨミガナ

  # セッション初期化処理
  def session_init?(controller=@controller, login_id=nil)
    session = ActionController::TestSession.new
    # 機能状態ハッシュ生成
    state_hash = FunctionState::FunctionStateHash.new
    @controller.session[:function_state_hash] = state_hash
    # 機能状態生成
    state = state_hash.new_state(controller, nil, true)
    if state.nil? then
      return false
    end
    @controller.session[:function_state] = state
    @controller.session[:login_id] = login_id unless login_id.nil?
    @request.session = @controller.session
    return true
  end
  
  # 状態生成
  def new_state(controller=@controller, prev_trans_no=nil, sept_flg=false)
    if String === controller then
      dmy_controller = Object.new
      class << dmy_controller
        public
        def controller_path
          return @controller_path
        end
        def controller_path=(controller_path)
          @controller_path = controller_path
        end
        def logger
          return @logger
        end
        def logger=(logger)
          @logger = logger
        end
      end
      dmy_controller.controller_path = controller
      dmy_controller.logger = Rails.logger
      controller = dmy_controller
    end
    state_hash = session[:function_state_hash]
    state = session[:function_state]
    return state_hash.new_state(controller, prev_trans_no, sept_flg)
  end
  
  # リクエストパラメータの生成
  def create_params(transition_pattern, func_tran_no, restored_transition_no=nil)
    # 画面遷移情報で初期化
    session_init? if session.nil?
    pattern = Common::SessionUtilModule.const_get(transition_pattern)
    state_hash = session[:function_state_hash]
    state = state_hash[func_tran_no]
    params = {:screen_transition_pattern=>pattern,
              :function_transition_no=>state.func_tran_no,
              :synchronous_token=>state.sync_tkn}
    unless restored_transition_no.nil? then
      params[:restored_transition_no] = restored_transition_no
    end
    return params
  end
  
  # フラッシュチェック
  def valid_flash(transition_pattern, func_tran_no, restored_transition_no, err_msg='state invalid!')
    pattern = Common::SessionUtilModule.const_get(transition_pattern)
    state_hash = session[:function_state_hash]
    state = state_hash[func_tran_no]
    params = flash[:params]
#    print_log('Flash screen_transition_pattern:' + params[:screen_transition_pattern].to_s)
    assert(params[:screen_transition_pattern] == pattern, err_msg)
#    print_log('Flash function_transition_no:' + params[:function_transition_no].to_s)
    assert(params[:function_transition_no] == func_tran_no.to_s, err_msg)
#    print_log('Flash synchronous_token:' + params[:synchronous_token].to_s)
    assert(params[:synchronous_token] == state.sync_tkn, err_msg)
    unless restored_transition_no.nil? then
#      print_log('Flash restored_transition_no:' + params[:restored_transition_no].to_s)
      assert(params[:restored_transition_no] == restored_transition_no, err_msg)
    end
  end

  # 機能ステートチェック
  def valid_state(cntr_path, func_tran_no, prev_tran_no, sept_flg, err_msg='state invalid!')
    state_hash = session[:function_state_hash]
    state = state_hash[func_tran_no]
#    state = @request.session[:function_state]
#    print_log('Function State cntr_path:' + state.cntr_path.to_s)
    assert(state.cntr_path == cntr_path, err_msg)
#    print_log('Function State func_tran_no:' + state.func_tran_no.class.to_s)
    assert(state.func_tran_no == func_tran_no, err_msg)
#    print_log('Function State prev_tran_no:' + state.prev_tran_no.to_s)
    assert(state.prev_tran_no == prev_tran_no, err_msg)
#    print_log('Function State sept_flg:' + state.sept_flg.to_s)
    assert(state.sept_flg == sept_flg, err_msg)
#    print_log('Function State sync_tkn.length:' + state.sync_tkn.length.to_s)
    assert(state.sync_tkn.length == 40, err_msg)
  end
  
  # コンボボックスチェック
  def valid_combo(selector, combo_hash, err_msg='combo invalid!', sel_val=nil)
    # selectタグチェック
    assert_select(selector, true, err_msg)
    # 値チェック
    valid_options(selector + '', combo_hash, err_msg, sel_val)
  end
  
  # コンボボックスチェック
  def valid_options(selector, combo_hash, err_msg='options invalid!', sel_val=nil)
    # 値チェック
    combo_hash.each_pair do |key, val|
      opt_err_msg = err_msg + '(' + key.to_s + ',' + val.to_s + ')'
      if Hash === val then
        next_sel = selector + '>optgroup[label="' + key.to_s + '"]'
#        Rails.logger.debug('Selector:' + next_sel)
        assert_select(next_sel, true, opt_err_msg)
        valid_options(next_sel, val, opt_err_msg, sel_val)
      else
        val_selector = selector + '>option[value="' + val.to_s + '"]'
#        Rails.logger.debug('Selector:' + val_selector)
        assert_select(val_selector, key, opt_err_msg)
        if val == sel_val then
          assert_select(val_selector + '[selected]', true, opt_err_msg)
        end
      end
    end
  end
  
  # 画面遷移パラメータチェック
  def valid_scr_param(selector, state, tran_ptn, rest_no, err_msg='scr params invalid!')
#    Rails.logger.debug('Selector:' + selector + ' #screen_transition_pattern[value="' + tran_ptn.to_s + '"]')
    assert_select(selector + ' #screen_transition_pattern[value="' + tran_ptn.to_s + '"]', true, err_msg)
#    Rails.logger.debug('Selector:' + selector + ' #function_transition_no[value="' + state.func_tran_no.to_s + '"]')
    assert_select(selector + ' #function_transition_no[value="' + state.func_tran_no.to_s + '"]', true, err_msg)
    assert_select(selector + ' #synchronous_token[value="' + state.sync_tkn + '"]', true, err_msg)
    unless rest_no.nil? then
      assert_select(selector + ' #restored_transition_no[value="' + rest_no.to_s + '"]', true, err_msg)
    end
  end
  
  # ランダム文字列生成
  def generate_str(character_set, size)
    # 生成対象の文字コードセット
    # 文字コードセットからランダムに文字を抽出して、指定された桁数の文字列を生成
    return Array.new(size){character_set[rand(character_set.size)]}.join
  end
    
  # アクション実行
  def exec_action(action, method, params={})
    case method.to_s
    when 'get'
      get(action, params)
    when 'post'
      post(action, params)
    end
  end
  
  # ログメッセージ出力
  def print_log(message)
    Rails.logger.info(message)
  end
  
  # エラーログメッセージ出力
  def error_log(message, ex=nil)
    if ActiveModel::Errors === ex then
      ex.errors.each do |attr, msg|
        Rails.logger.error(message + ":" + attr + ":" + msg)
      end
    else
      Rails.logger.error(message)
    end
  end
  
  # 日時フォーマット
  def default_time(time=Time.now)
    return '' if time.nil?
    time_format = I18n.t('time.formats.default')
    return time.strftime(time_format)
  end
end