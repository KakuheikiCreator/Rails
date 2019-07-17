# -*- coding: utf-8 -*-
###############################################################################
# 会員検索クラス
# 機能：会員データの検索を行うクラス
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/03/07 Nakanohito
# 更新日:
###############################################################################
require 'singleton'
require 'biz_common/business_config'

module BizSearch
  # 会員検索クラス
  class MemberSearch
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
    # 会員データ検索（キー：会員ID）
    def find_by_member_id(member_id, size=nil)
      # Solrで検索
      size ||= @max_search_size
      search = Member.search do
        fulltext(member_id.to_s) do fields(:member_id) end
        order_by(:score, :desc)
        paginate(:page=>1, :per_page=>size)
      end
      return search
    end
    
    # 会員データ検索（キー：OpenID）
    def find_by_open_id(open_id, size=nil)
      # Solrで検索
      size ||= @max_search_size
      search = Member.search do
        fulltext(open_id) do fields(:open_id) end
        order_by(:score, :desc)
        paginate(:page=>1, :per_page=>size)
      end
      return search
    end
    
    # 会員データ検索（キー：ニックネーム）
    def find_by_nickname(nickname, size=nil)
      # Solrで検索
      size ||= @max_search_size
      search = Member.search do
        fulltext(nickname.to_s) do fields(:nickname) end
        order_by(:score, :desc)
        paginate(:page=>1, :per_page=>size)
      end
      return search
    end
  end
end