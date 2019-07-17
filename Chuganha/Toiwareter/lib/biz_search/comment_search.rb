# -*- coding: utf-8 -*-
###############################################################################
# コメント検索クラス
# 機能：コメントデータの検索を行うクラス
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/02/09 Nakanohito
# 更新日:
###############################################################################
require 'singleton'
require 'biz_common/business_config'

module BizSearch
  # コメント検索クラス
  class CommentSearch
    include Singleton
    include BizCommon
    ###########################################################################
    # メソッド定義
    ###########################################################################
    # コンストラクタ
    def initialize
      # 最大検索結果件数
      @max_search_size = BusinessConfig.instance[:max_comment_search_results_size]
    end
    
    ###########################################################################
    # publicメソッド定義
    ###########################################################################
    public
    # 全文検索
    def full(comment)
      search = Comment.search do
        fulltext(comment.to_s)
        order_by(:score, :desc)
        paginate(:page=>1, :per_page=>@max_search_size)
      end
      return search.results
    end

    # 詳細検索
    def detail(comment, member_id, criticism_date, criticism_date_comp)
      search = Comment.search do
        # コメント
        unless comment.nil? then
          fulltext(comment) do fields(:comment) end
        end
        # 会員ID
        unless member_id.nil? then
          fulltext(member_id) do fields(:critic_member_id) end
        end
        # コメント日時
        unless criticism_date.nil? then
          case criticism_date_comp
          when 'EQ' then # と一致
            with(:criticism_date).equal_to(criticism_date)
          when 'NE' then # と不一致
            without(:criticism_date, criticism_date)
          when 'LT' then # より小さい
            with(:criticism_date).less_than(criticism_date)
          when 'GT' then # より大きい
            with(:criticism_date).greater_than(criticism_date)
          when 'LE' then # 以下
            without(:criticism_date).greater_than(criticism_date)
          when 'GE' then # 以上
            without(:criticism_date).less_than(criticism_date)
          end
        end
        order_by(:score, :desc)
        paginate(:page=>1, :per_page=>@max_search_size)
      end
      return search.results
    end
    
    # 引用に対するコメント
    def quote_comment(quote_id)
      return [] unless numeric?(quote_id)
      search = Comment.search do
        with(:quote_id, quote_id.to_i)
        order_by(:seq_no, :asc)
        paginate(:page=>1, :per_page=>100)
      end
      return search.results
    end
    
    ###########################################################################
    # protected定義
    ###########################################################################
    protected
    # 数値チェック
    def numeric?(val)
      return true if Integer === val
      return Common::ValidationChkModule.numeric?(val)
    end
  end
end