# -*- coding: utf-8 -*-
###############################################################################
# 機能状態スタックハッシュ
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2011/09/03 Nakanohito
# 更新日:
###############################################################################
require 'function_state/function_state'

module FunctionState
  class FunctionStateHash
    # アクセスメソッド定義
    attr_reader :max_size
    ###########################################################################
    # コンストラクタ
    ###########################################################################
    def initialize
      biz_config = BizCommon::BusinessConfig.instance
      @max_size = biz_config.max_function_state_hash_size
      @max_size ||= 30
      @state_hash = Hash.new
      @latest_func_tran_no = 0
    end
    
    ###########################################################################
    # publicメソッド定義
    ###########################################################################
    public
    # 最大サイズ判定
    def max_size?
      return @state_hash.size >= @max_size
    end
    
    # 最大サイズ設定処理
    def set_max_size?(size)
      return false if size < @state_hash.size
      @max_size = size
      return true
    end
    
    # 状態取得
    def [](transition_no)
      # 引数チェック
      return @state_hash[transition_no]
    end
    
    # 直前の状態取得
    def previous_state(func_tran_no, target_path=nil)
      # 引数チェック
      state = @state_hash[func_tran_no]
      return nil if state.nil? || state.sept_flg
      # 直前の状態の取得
      prev_state = @state_hash[state.prev_tran_no]
      return prev_state if target_path.nil?
      until prev_state.nil? do
        break if prev_state.cntr_path == target_path
        return nil if prev_state.sept_flg
        prev_state = @state_hash[prev_state.prev_tran_no]
      end
      return prev_state
    end
    
    # 機能状態新規生成
    def new_state(ctrl, prev_trans_no, sept_flg=false)
      # 前機能状態チェック
      prev_state = nil
      if prev_trans_no.nil? then
        sept_flg = true
      else
        prev_state = @state_hash[prev_trans_no]
        return nil if prev_state.nil?
      end
      # ハッシュサイズチェック
      if sept_flg then
        # 前機能状態のチェック
        return nil if @state_hash.size >= @max_size
      else
        # 前機能状態のチェック
        return nil if prev_state.next_tran_no.nil? && @state_hash.size >= @max_size
      end
      # 機能状態生成
      state = create_function_state(ctrl, prev_trans_no, sept_flg)
      return nil if state.nil?
      # 前機能状態の関連付け替え処理
      join_next?(prev_state, state)
      return state
    end
    
    # 機能状態置換
    def replace_state(ctrl, func_trans_no)
      # パラメータチェック
      return nil if func_trans_no.nil?
      target_state = @state_hash[func_trans_no]
      return nil if target_state.nil?
      # 機能状態生成
      prev_trans_no = target_state.prev_tran_no
      rep_state = create_function_state(ctrl, prev_trans_no, target_state.sept_flg)
      return nil if rep_state.nil?
      # 機能状態の関連付け替え処理
      join_next?(@state_hash[prev_trans_no], rep_state)
      @state_hash.delete(func_trans_no)
      return rep_state
    end
    
    # 機能状態削除
    def delete?(func_tran_no)
      state = @state_hash[func_tran_no]
      return false if state.nil?
      delete_next?(state)
      unless state.sept_flg then
        prev_state = @state_hash[state.prev_tran_no]
        prev_state.next_tran_no = nil unless prev_state.nil?
      end
      @state_hash.delete(func_tran_no)
      return true
    end
    
    # 機能状態履歴削除
    def delete_history?(func_tran_no, return_tran_no=nil)
      # 削除対象の遷移番号抽出
      start_state = @state_hash[func_tran_no]
      return false if start_state.nil? || (!return_tran_no.nil? && func_tran_no <= return_tran_no)
      delete_keys = Array.new
      chk_state = start_state
      if return_tran_no.nil? then
        # 分離ポイントまでを削除
        until chk_state.nil? do
          delete_keys.push(chk_state.func_tran_no)
          break if chk_state.sept_flg
          chk_state = @state_hash[chk_state.prev_tran_no]
        end
      else
        # 戻る先の機能状態の直前まで削除
        until chk_state.nil? do
          delete_keys.push(chk_state.func_tran_no)
          break if chk_state.prev_tran_no == return_tran_no
          return false if chk_state.sept_flg
          chk_state = @state_hash[chk_state.prev_tran_no]
        end
      end
      # 戻る先以降を削除
      return false if chk_state.nil?
      delete_next?(start_state) # 起点以降の機能状態を削除
      # 戻る先以降の機能状態を削除
      @state_hash[chk_state.prev_tran_no].next_tran_no = nil unless chk_state.sept_flg
      delete_keys.each do |key| @state_hash.delete(key) end
      return true
    end
    
    # 機能状態全削除
    def delete_all
      @state_hash = Hash.new
    end
    
    ###########################################################################
    # protectedメソッド定義
    ###########################################################################
    protected
    # 機能状態生成
    def create_function_state(ctrl, prev_trans_no, sept_flg=false)
      state = nil
      begin
        cntr_path = ctrl.controller_path
        new_trans_no = @latest_func_tran_no + 1
        state = nil
        if ctrl.respond_to?(:create_function_state) then
          state = ctrl.create_function_state(cntr_path, new_trans_no, prev_trans_no, sept_flg)
        else
          state = FunctionState.new(cntr_path, new_trans_no, prev_trans_no, sept_flg)
        end
        # プロパティの更新
        @latest_func_tran_no = new_trans_no
        @state_hash[new_trans_no] = state
      rescue StandardError => ex
        state = nil
        ctrl.logger.warn('Exception:' + ex.class.name)
        ctrl.logger.warn('Message  :' + ex.message)
        ctrl.logger.warn('Backtrace:' + ex.backtrace.join("\n"))
      end
      return state
    end
    
    # 状態の結合処理
    def join_next?(prev_state, next_state)
      return false if next_state.sept_flg
      # 現状で結合している次以降の状態を削除
      return false unless delete_next?(prev_state)
      # 次の状態を接続
      prev_state.next_tran_no = next_state.func_tran_no
      return true
    end
    
    # 次以降の状態の削除
    def delete_next?(prev_state)
      return false if prev_state.nil?
      state = prev_state
      while !state.next_tran_no.nil? && !@state_hash[state.next_tran_no].sept_flg do
        state = @state_hash.delete(state.next_tran_no)
      end
      prev_state.next_tran_no = nil
      return true
    end
  end
end