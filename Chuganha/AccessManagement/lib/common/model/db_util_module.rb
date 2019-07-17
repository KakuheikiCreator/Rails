# -*- coding: utf-8 -*-
###############################################################################
# データベースユーティリティモジュール
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/07/28 Nakanohito
# 更新日:
###############################################################################

module Common
  module Model
    module DbUtilModule
      COMP_STATEMENT_HASH = {'EQ'=>' = ?', 'NE'=>' <> ?',
                             'LT'=>' < ?', 'GT'=>' > ?',
                             'LE'=>' <= ?', 'GE'=>' >= ?'}
      #########################################################################
      # protectedメソッド定義
      #########################################################################
      protected
      # Like演算子用エスケープ処理
      def like_escape(val)
        return val if val.nil?
        esc_val = val.gsub('\\', '\\\\\\\\')
        esc_val = esc_val.gsub('%', '\\%')
        esc_val = esc_val.gsub('_', '\\_')
        return esc_val
      end
      
      # 比較ステートメント
      def comp_statement(item_name, comp_cond)
        return item_name + COMP_STATEMENT_HASH[comp_cond]
      end
      
      # マッチングステートメント
      def match_statement(item_name, match_cond)
        return item_name + ' = ?' if match_cond == 'E'
        return item_name + ' like ?'
      end
      
      # マッチングパラメータ
      def match_param(param, match_cond)
        like_val = like_escape(param)
        return like_val if match_cond == 'E'
        return like_val + '%' if match_cond == 'F'
        return '%' + like_val + '%' if match_cond == 'P'
        return '%' + like_val if match_cond == 'B'
        return nil
      end
      
      # 等価結合（NULL対応）
      def full_join(item_a, item_b)
        return '(' + item_a + ' = ' + item_b + ' OR ' + item_a + ' IS NULL AND ' + item_b + ' IS NULL)'
      end
    end
  end
end