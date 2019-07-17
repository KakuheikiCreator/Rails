# -*- coding: utf-8 -*-
###############################################################################
# Where句生成クラス
# 概要：データモデルにおけるwhere句のクエリメソッドの条件生成を行うクラス
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2012/09/05 Nakanohito
# 更新日:
###############################################################################
require 'common/model/db_util_module'

module Common
  module Model
    class WhereClause
      include Common::Model::DbUtilModule
      #########################################################################
      # メソッド定義
      #########################################################################
      # 初期化メソッド
      def initialize
        # 抽出条件文字列
        @where_clause = Array.new
        # バインド変数配列
        @bind_params = Array.new
        # 接続詞フラグ
        @conjunction_flg = false
      end
      
      #########################################################################
      # public定義
      #########################################################################
      public
      # AND句
      def and
        @where_clause.push(' and ') if @conjunction_flg
        @conjunction_flg = false
        return self
      end
      
      # OR句
      def or
        @where_clause.push(' or ') if @conjunction_flg
        @conjunction_flg = false
        return self
      end
      
      # 条件ブロック追加
      def block(&block)
        self.and # 接続詞が指定されていない場合にはANDで接続
        @where_clause.push('(')
        block.call(self)
        @where_clause.push(')')
        @conjunction_flg = true
        return self
      end
      
      # 条件追加（完全一致、範囲、IN句）
      def where(*cond)
        return where_hash(cond[0]) if Hash === cond[0]
        return where_array(cond)
      end
      
      # LIKE演算子
      def like(cond, esc_flg=false)
        cond.each do |key, value|
          self.and # 接続詞が指定されていない場合にはANDで接続
          @where_clause.push(key.to_s)
          @where_clause.push(' like ?')
          value = like_escape(value) if esc_flg
          @bind_params.push(value)
          @conjunction_flg = true
        end
        return self
      end
      
      # 前方一致
      def f_match(cond)
        f_match_cond = Hash.new
        cond.each do |key, value|
          f_match_cond[key] = like_escape(value) + '%'
        end
        return like(f_match_cond)
      end
      
      # 部分一致
      def p_match(cond)
        p_match_cond = Hash.new
        cond.each do |key, value|
          p_match_cond[key] = '%' + like_escape(value) + '%'
        end
        return like(p_match_cond)
      end
      
      # 後方一致
      def b_match(cond)
        b_match_cond = Hash.new
        cond.each do |key, value|
          b_match_cond[key] = '%' + like_escape(value)
        end
        return like(b_match_cond)
      end
      
      # 抽出条件生成
      def to_condition
        return [] if @where_clause.empty?
        return [@where_clause.join] if @bind_params.empty?
        return [@where_clause.join] + @bind_params
      end
      
      #########################################################################
      # protected定義
      #########################################################################
      protected      
      # where句条件追加（引数：ハッシュ）
      def where_hash(cond)
        cond.each do |key, value|
          self.and # 接続詞が指定されていない場合にはANDで接続
          @where_clause.push(key.to_s)
          @where_clause.push(' = ?')
          @bind_params.push(value)
          @conjunction_flg = true
        end
        return self
      end
      
      # where句条件追加（引数：配列）
      def where_array(cond)
        self.and # 接続詞が指定されていない場合にはANDで接続
        @where_clause.push(cond[0].to_s)
        length = cond.length
        cond[1, length].each do |value|
          @bind_params.push(value)
        end
        @conjunction_flg = true
        return self
      end
    end
  end
end