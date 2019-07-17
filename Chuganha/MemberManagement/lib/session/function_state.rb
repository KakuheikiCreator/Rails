###############################################################################
# 機能状態クラス
# Copyright:: Copyright (c) 2011 仲務省
# 作成日:2011/07/09 Nakanohito
# 更新日:
###############################################################################
module Session
  class FunctionState
    ###########################################################################
    # メソッド定義
    ###########################################################################
    # アクセスメソッド定義
    attr_accessor(:transaction_no)
    attr_reader(:function_id,
                :function_transition_no)
    
    # 初期化メソッド
    def initialize(function_id, function_transition_no=0, transaction_no=0)
      @function_id            = function_id               # 機能ID
      @function_transition_no = function_transition_no    # 機能遷移番号
      @transaction_no         = transaction_no            # トランザクション番号
    end
  end
end
