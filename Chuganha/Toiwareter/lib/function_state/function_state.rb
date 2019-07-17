# -*- coding: utf-8 -*-
###############################################################################
# 機能状態クラス
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2011/09/03 Nakanohito
# 更新日:
###############################################################################
require 'digest/sha1'

module FunctionState
  class FunctionState
    # アクセスメソッド定義
    attr_accessor :next_tran_no
    attr_reader :cntr_path, :func_tran_no, :prev_tran_no, :sept_flg, :sync_tkn
    ###########################################################################
    # メソッド定義
    ###########################################################################
    # 初期化メソッド
    def initialize(cntr_path, func_tran_no, prev_tran_no, sept_flg=false)
      @cntr_path     = cntr_path       # コントローラーパス
      @func_tran_no  = func_tran_no    # 機能遷移番号
      @prev_tran_no  = prev_tran_no    # 起動元機能遷移番号
      @next_tran_no  = nil             # 遷移先機能遷移番号
      @sept_flg      = sept_flg        # 分離フラグ（新しいウィンドウで開かれた場合はTrue）
      @sync_tkn      = generate_token  # 同期トークン
    end
    
    public
    # 同期トークンの更新
    def update_token
      @sync_tkn = generate_token
      return @sync_tkn
    end
    
    protected
    # 同期トークン生成
    def generate_token
      now = Time.now
      return Digest::SHA1.hexdigest(@func_tran_no.to_s + now.to_s + now.usec.to_s)
    end
  end
end
