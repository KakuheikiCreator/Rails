# -*- coding: utf-8 -*-
###############################################################################
# 引用検索クラス
# 機能：引用データの検索を行うクラス
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/02/03 Nakanohito
# 更新日:
###############################################################################
require 'singleton'
require 'common/validation_chk_module'
require 'biz_common/business_config'
require 'biz_common/biz_morpheme_parser'

module BizSearch
  # 引用検索クラス
  class QuoteSearch
    include Singleton
    include BizCommon
    ###########################################################################
    # メソッド定義
    ###########################################################################
    # コンストラクタ
    def initialize
      # 最大検索結果件数
      @max_search_size = BusinessConfig.instance[:max_quote_search_results_size]
    end
    
    ###########################################################################
    # publicメソッド定義
    ###########################################################################
    public
    # 全文検索
    def full(quote)
      search = Quote.search do
        fulltext(quote.to_s)
        order_by(:score, :desc)
        paginate(:page=>1, :per_page=>@max_search_size)
      end
      return search.results
    end

    # 詳細検索
    def detail(cond_params)
      # 検索処理
      search = Quote.search do
        # 引用文
        quote = cond_params[:quote]
        unless quote.nil? then
          fulltext(quote) do fields(:quote) end
        end
        # 発言者
        speaker = cond_params[:speaker]
        unless speaker.nil? then
          fulltext(speaker) do fields(:speaker) end
        end
        # 発言者肩書きID
        speaker_job_title_id = cond_params[:speaker_job_title_id]
        unless speaker_job_title_id.nil? then
          with(:speaker_job_title_id, speaker_job_title_id.to_i)
        end
        # 発言者肩書き
        speaker_job_title = cond_params[:speaker_job_title]
        unless speaker_job_title.nil? then
          fulltext(speaker_job_title) do fields(:speaker_job_title) end
        end
        # 引用文説明
        description = cond_params[:description]
        unless description.nil? then
          fulltext(description) do fields(:description) end
        end
        # 投稿者
        registered_member_id = cond_params[:registered_member_id]
        unless registered_member_id.nil? then
          fulltext(registered_member_id) do fields(:registered_member_id) end
        end
        # 訂正者
        update_member_id = cond_params[:update_member_id]
        unless update_member_id.nil? then
          fulltext(update_member_id) do fields(:update_member_id) end
        end
        # 投稿日時
        registered_date      = cond_params[:registered_date]
        registered_date_comp = cond_params[:registered_date_comp]
        unless registered_date.nil? then
          case registered_date_comp
          when 'EQ' then # と一致
            with(:registered_date).equal_to(registered_date)
          when 'NE' then # と不一致
            without(:registered_date, registered_date)
          when 'LT' then # より小さい
            with(:registered_date).less_than(registered_date)
          when 'GT' then # より大きい
            with(:registered_date).greater_than(registered_date)
          when 'LE' then # 以下
            without(:registered_date).greater_than(registered_date)
          when 'GE' then # 以上
            without(:registered_date).less_than(registered_date)
          end
        end
        order_by(:score, :desc)
        paginate(:page=>1, :per_page=>@max_search_size)
      end
      return search.results
    end
    
    # 重複
    def duplicate(quote, speaker=nil)
      return [] if blank?(quote)
      cond_quote = "\"#{quote}\""
      cond_speaker = nil
      cond_speaker = "\"#{speaker}\"" unless blank?(speaker)
      # 検索処理
      result_list = search_solr(cond_quote, cond_speaker)
      # エスケープ文字を無視して検索するので対応
      result_list.delete_if do |ent|
        !ent.quote.include?(quote) || ent.speaker != speaker
      end
      return result_list
    end
    
    # 類似引用検索
    def similar_search(quote, speaker=nil)
      keywords = conv_keywords(quote)
      return [] if keywords.empty?
      # 検索処理
      return search_solr(keywords.join(' '), speaker)
    end
    
    ###########################################################################
    # protected定義
    ###########################################################################
    protected
    # ブランクチェック
    def blank?(val)
      return Common::ValidationChkModule.blank?(val)
    end
    
    # キーワード変換（動詞・名詞）
    def conv_keywords(quote)
      return [] if blank?(quote)
      # 形態素解析
      origin_list = BizMorphemeParser.instance.keyword_extraction(quote)
      # 出現頻度に合わせて並べ替え
      keyword_hash = Hash.new
      origin_list.each do |word|
        keyword_hash[word] ||= 0
        keyword_hash[word] += 1
      end
      list = keyword_hash.sort do |a,b| -(a[1]<=>b[1]) end
      sorted_list = Array.new
      list.each do |elm| sorted_list.push(elm[0]) end
      return sorted_list
    end
    
    # 引用検索（Solr）
    def search_solr(cond_quote, cond_speaker=nil, limit_cnt=nil)
      limit_cnt ||= @max_search_size
      return [] if blank?(cond_quote)
      search = nil
      if blank?(cond_speaker) then
        search = Quote.search do
          fulltext(cond_quote) do fields(:quote) end
          order_by(:score, :desc)
          paginate(:page=>1, :per_page=>limit_cnt)
        end
      else
        search = Quote.search do
          fulltext(cond_quote) do fields(:quote) end
          fulltext(cond_speaker) do fields(:speaker) end
          order_by(:score, :desc)
          paginate(:page=>1, :per_page=>limit_cnt)
        end
      end
      return search.results
    end
  end
end