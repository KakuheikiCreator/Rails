###############################################################################
# 機能状態スタッククラス
# Copyright:: Copyright (c) 2011 仲務省
# 作成日:2011/07/10 Nakanohito
# 更新日:
###############################################################################
require 'common/validation_chk_module'

module Session
  class FunctionStateStack
    include Common::ValidationChkModule
    
    ###########################################################################
    # メソッド定義
    ###########################################################################
    # アクセスメソッド定義
    attr_accessor(:stack_max_size)
    
    # 初期化メソッド
    def initialize(stack_max_size)
      @stack_max_size = stack_max_size
      @stack = Array.new(@stack_max_size)
      @stack_top = 0
    end
    
    ###########################################################################
    # publicメソッド定義
    ###########################################################################
    public
    
    # プッシュ
    def push?(function_state)
      # プッシュ対象チェック
      raise ArgumentError.new('Parameter Type Error') unless FunctionState === function_state
      # プッシュ処理
      if @stack_top < @stack_max_size then
        @stack[@stack_top] = function_state
        @stack_top += 1
        return true
      else
        return false
      end
    end
    
    # ポップ
    def pop(function_id=nil)
      raise 'Empty Stack Error' if @stack_top < 1
      # 先頭をポップ
      if function_id == nil then
        @stack_top -= 1
        return @stack[@stack_top]
      end
      # 機能IDを指定してポップ
      (@stack_top - 1).downto(0) do |stack_pos|
        if @stack[stack_pos].function_id == function_id then
          @stack_top = stack_pos
          return @stack[@stack_top]
        end
      end
      raise 'No target data Error'
    end
    
    # スタック頂点の取得
    def top
      return @stack[@stack_top - 1] if @stack_top > 0
      return nil
    end
    
    # スタッククリア
    def clear
      @stack_top = 0
      @stack     = Array.new(@stack_max_size)
    end
    
    # サイズ取得
    def size
      return @stack_top
    end
  end
end