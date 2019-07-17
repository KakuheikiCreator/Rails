# -*- coding: utf-8 -*-
###############################################################################
# 機能状態クラス（ハッシュ型）
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2012/12/27 Nakanohito
# 更新日:
###############################################################################
require 'function_state/function_state'

module FunctionState
  class HashState < FunctionState
    ###########################################################################
    # メソッド定義
    ###########################################################################
    # 初期化メソッド
    def initialize(cntr_path, func_tran_no, prev_tran_no, sept_flg)
      super(cntr_path, func_tran_no, prev_tran_no, sept_flg)
      @state_parames = nil
    end
    
    ###########################################################################
    # publicメソッド定義
    ###########################################################################
    public
    # パラメータ参照
    def [](param_key)
      return nil if @state_parames.nil?
      return @state_parames[param_key]
    end
    
    # パラメータ設定
    def []=(param_key, param_value)
      @state_parames = Hash.new if @state_parames.nil?
      @state_parames[param_key] = param_value
      return nil
    end
  end
end
