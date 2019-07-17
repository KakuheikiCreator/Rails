# -*- coding: utf-8 -*-
###############################################################################
# 番号採番クラス
# 機能：番号データの採番処理を行う
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/01/10 Nakanohito
# 更新日:
###############################################################################
require 'singleton'
require 'thread'

module BizCommon
  # 番号採番クラス
  class BizNumbering
    include Singleton
    ###########################################################################
    # メソッド定義
    ###########################################################################
    # コンストラクタ
    def initialize
      # 排他制御オブジェクト生成
      @mutex = Mutex.new
    end
    
    ###########################################################################
    # publicメソッド定義
    ###########################################################################
    public
    # 採番号処理
    def next_number(num_cls, num_item)
      # クリティカルセクションの実行
      @mutex.synchronize do
        # 番号検索
        num_ent = now_number(num_cls, num_item)
        return new_number(num_cls, num_item).number if num_ent.nil?
        num_ent.number += 1
        num_ent.save!
        return num_ent.number
      end
    end
    
    ###########################################################################
    # protectedメソッド定義
    ###########################################################################
    protected
    # 現在番号検索
    def now_number(num_cls, num_item)
      return Number.where(:number_cls=>num_cls.to_s, :number_item=>num_item.to_s)[0]
    end
    
    # 新規レコード生成
    def new_number(num_cls, num_item)
      ent = Number.new(:number_cls=>num_cls.to_s, :number_item=>num_item.to_s, :number=>1)
      ent.save!
      return ent
    end
  end
end