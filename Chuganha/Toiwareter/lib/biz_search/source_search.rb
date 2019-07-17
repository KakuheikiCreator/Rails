# -*- coding: utf-8 -*-
###############################################################################
# 出所検索クラス
# 機能：出所データの検索を行うクラス
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/02/07 Nakanohito
# 更新日:
###############################################################################
require 'singleton'
require 'biz_common/business_config'

module BizSearch
  # 出所検索クラス
  class SourceSearch
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
    # 出所検索
    def find_source(source_id, id)
      # クリティカルセクションの実行
      return nil unless numeric?(source_id)
      return nil unless numeric?(id)
      case source_id.to_i
      when 1 then # 新聞
        return SourceNewspaper.where(:quote_id=>id.to_i)[0]
      when 2 then # 雑誌
        return SourceMagazine.where(:quote_id=>id.to_i)[0]
      when 3 then # 書籍
        return SourceBook.where(:quote_id=>id.to_i)[0]
      when 4 then # テレビ
        return SourceTv.where(:quote_id=>id.to_i)[0]
      when 5 then # ラジオ
        return SourceRadio.where(:quote_id=>id.to_i)[0]
      when 6 then # 音楽
        return SourceMusic.where(:quote_id=>id.to_i)[0]
      when 7 then # 動画
        return SourceMovie.where(:quote_id=>id.to_i)[0]
      when 8 then # ゲーム
        return SourceGame.where(:quote_id=>id.to_i)[0]
      when 9 then # ニュースサイト
        return SourceNewsSite.where(:quote_id=>id.to_i)[0]
      when 10 then # Twitter
        return SourceTwitter.where(:quote_id=>id.to_i)[0]
      when 11 then # ブログ
        return SourceBlog.where(:quote_id=>id.to_i)[0]
      when 12 then # SNS
        return SourceSns.where(:quote_id=>id.to_i)[0]
      when 13 then # 電子掲示板
        return SourceBbs.where(:quote_id=>id.to_i)[0]
      when 14 then # その他サイト
        return SourceOtherSite.where(:quote_id=>id.to_i)[0]
      when 15 then # その他
        return SourceOther.where(:quote_id=>id.to_i)[0]
      else
        return nil
      end
    end
    
    # 詳細検索
    def detail(cond_params)
      # クリティカルセクションの実行
      source_id = cond_params[:source_id]
      return nil unless numeric?(source_id)
      case source_id.to_i
      when 1 then # 新聞
        return dtl_newspaper(cond_params)
      when 2 then # 雑誌
        return dtl_magazine(cond_params)
      when 3 then # 書籍
        return dtl_book(cond_params)
      when 4 then # テレビ
        return dtl_tv(cond_params)
      when 5 then # ラジオ
        return dtl_radio(cond_params)
      when 6 then # 音楽
        return dtl_music(cond_params)
      when 7 then # 動画
        return dtl_movie(cond_params)
      when 8 then # ゲーム
        return dtl_game(cond_params)
      when 9 then # ニュースサイト
        return dtl_news_site(cond_params)
      when 10 then # Twitter
        return dtl_twitter(cond_params)
      when 11 then # ブログ
        return dtl_blog(cond_params)
      when 12 then # SNS
        return dtl_sns(cond_params)
      when 13 then # 電子掲示板
        return dtl_bbs(cond_params)
      when 14 then # その他サイト
        return dtl_other_site(cond_params)
      when 15 then # その他
        return dtl_other(cond_params)
      else
        return nil
      end
    end
    
    ###########################################################################
    # protectedメソッド定義
    ###########################################################################
    protected
    # 数値チェック
    def numeric?(val)
      return true if Integer === val
      return Common::ValidationChkModule.numeric?(val)
    end
    
    # 詳細検索（新聞）
    def dtl_newspaper(cond_params)
      # 検索処理
      search = SourceNewspaper.search do
        # 新聞名
        newspaper_name = cond_params[:media_name]
        unless newspaper_name.nil? then
          fulltext(newspaper_name) do fields(:newspaper_name) end
        end
        # 日付・刊
        posted_date      = cond_params[:distribution_date]
        posted_date_comp = cond_params[:distribution_date_comp]
        unless posted_date.nil? then
          case posted_date_comp
          when 'EQ' then # と一致
            with(:posted_date).equal_to(posted_date)
          when 'NE' then # と不一致
            without(:posted_date, posted_date)
          when 'LT' then # より小さい
            with(:posted_date).less_than(posted_date)
          when 'GT' then # より大きい
            with(:posted_date).greater_than(posted_date)
          when 'LE' then # 以下
            without(:posted_date).greater_than(posted_date)
          when 'GE' then # 以上
            without(:posted_date).less_than(posted_date)
          end
        end
        # 記者
        reporter = cond_params[:reporter]
        unless reporter.nil? then
          fulltext(reporter) do fields(:reporter) end
        end
        # 記者肩書きID
        job_title_id = cond_params[:reporter_job_title_id]
        unless job_title_id.nil? then
          with(:job_title_id, job_title_id.to_i)
        end
        # 記者肩書き
        job_title = cond_params[:reporter_job_title]
        unless job_title.nil? then
          fulltext(job_title) do fields(:job_title) end
        end
        order_by(:score, :desc)
        paginate(:page=>1, :per_page=>@max_search_size)
      end
      return search.results
    end
    
    # 詳細検索（雑誌）
    def dtl_magazine(cond_params)
      # 検索処理
      search = SourceMagazine.search do
        # 雑誌名
        magazine_name = cond_params[:media_name]
        unless magazine_name.nil? then
          fulltext(magazine_name) do fields(:magazine_name) end
        end
        # 出版社
        publisher = cond_params[:media_name]
        unless publisher.nil? then
          fulltext(publisher) do fields(:publisher) end
        end
        # 発売日
        release_date      = cond_params[:distribution_date]
        release_date_comp = cond_params[:distribution_date_comp]
        unless release_date.nil? then
          case release_date_comp
          when 'EQ' then # と一致
            with(:release_date).equal_to(release_date)
          when 'NE' then # と不一致
            without(:release_date, release_date)
          when 'LT' then # より小さい
            with(:release_date).less_than(release_date)
          when 'GT' then # より大きい
            with(:release_date).greater_than(release_date)
          when 'LE' then # 以下
            without(:release_date).greater_than(release_date)
          when 'GE' then # 以上
            without(:release_date).less_than(release_date)
          end
        end
        # 記者
        reporter = cond_params[:reporter]
        unless reporter.nil? then
          fulltext(reporter) do fields(:reporter) end
        end
        # 記者肩書きID
        job_title_id = cond_params[:reporter_job_title_id]
        unless job_title_id.nil? then
          with(:job_title_id, job_title_id.to_i)
        end
        # 記者肩書き
        job_title = cond_params[:reporter_job_title]
        unless job_title.nil? then
          fulltext(job_title) do fields(:job_title) end
        end
        order_by(:score, :desc)
        paginate(:page=>1, :per_page=>@max_search_size)
      end
      return search.results
    end
    
    # 詳細検索（書籍）
    def dtl_book(cond_params)
      # 検索処理
      search = SourceBook.search do
        # 書籍名
        book_title = cond_params[:media_name]
        unless book_title.nil? then
          fulltext(book_title) do fields(:book_title) end
        end
        # 出版社
        publisher = cond_params[:media_name]
        unless publisher.nil? then
          fulltext(publisher) do fields(:publisher) end
        end
        # 発売日
        release_date      = cond_params[:distribution_date]
        release_date_comp = cond_params[:distribution_date_comp]
        unless release_date.nil? then
          case release_date_comp
          when 'EQ' then # と一致
            with(:release_date).equal_to(release_date)
          when 'NE' then # と不一致
            without(:release_date, release_date)
          when 'LT' then # より小さい
            with(:release_date).less_than(release_date)
          when 'GT' then # より大きい
            with(:release_date).greater_than(release_date)
          when 'LE' then # 以下
            without(:release_date).greater_than(release_date)
          when 'GE' then # 以上
            without(:release_date).less_than(release_date)
          end
        end
        # 著者
        author = cond_params[:reporter]
        unless author.nil? then
          fulltext(author) do fields(:author) end
        end
        # 著者肩書きID
        job_title_id = cond_params[:reporter_job_title_id]
        unless job_title_id.nil? then
          with(:job_title_id, job_title_id.to_i)
        end
        # 著者肩書き
        job_title = cond_params[:reporter_job_title]
        unless job_title.nil? then
          fulltext(job_title) do fields(:job_title) end
        end
        order_by(:score, :desc)
        paginate(:page=>1, :per_page=>@max_search_size)
      end
      return search.results
    end
    
    # 詳細検索（テレビ）
    def dtl_tv(cond_params)
      # 検索処理
      search = SourceTv.search do
        # 番組名
        program_name = cond_params[:media_name]
        unless program_name.nil? then
          fulltext(program_name) do fields(:program_name) end
        end
        any_of do
          # 放送局
          tv_station = cond_params[:media_name]
          unless tv_station.nil? then
            fulltext(tv_station) do fields(:tv_station) end
          end
          # 制作局
          production = cond_params[:media_name]
          unless production.nil? then
            fulltext(production) do fields(:production) end
          end
        end
        # 放送日時
        broadcast_date      = cond_params[:distribution_date]
        broadcast_date_comp = cond_params[:distribution_date_comp]
        unless broadcast_date.nil? then
          case broadcast_date_comp
          when 'EQ' then # と一致
            with(:broadcast_date).equal_to(broadcast_date)
          when 'NE' then # と不一致
            without(:broadcast_date, broadcast_date)
          when 'LT' then # より小さい
            with(:broadcast_date).less_than(broadcast_date)
          when 'GT' then # より大きい
            with(:broadcast_date).greater_than(broadcast_date)
          when 'LE' then # 以下
            without(:broadcast_date).greater_than(broadcast_date)
          when 'GE' then # 以上
            without(:broadcast_date).less_than(broadcast_date)
          end
        end
        order_by(:score, :desc)
        paginate(:page=>1, :per_page=>@max_search_size)
      end
      return search.results
    end
    
    # 詳細検索（ラジオ）
    def dtl_radio(cond_params)
      # 検索処理
      search = SourceRadio.search do
        # 番組名
        program_name = cond_params[:media_name]
        unless program_name.nil? then
          fulltext(program_name) do fields(:program_name) end
        end
        any_of do
          # 放送局
          radio_station = cond_params[:media_name]
          unless radio_station.nil? then
            fulltext(radio_station) do fields(:radio_station) end
          end
          # 制作局
          production = cond_params[:media_name]
          unless production.nil? then
            fulltext(production) do fields(:production) end
          end
        end
        # 放送日時
        broadcast_date      = cond_params[:distribution_date]
        broadcast_date_comp = cond_params[:distribution_date_comp]
        unless broadcast_date.nil? then
          case broadcast_date_comp
          when 'EQ' then # と一致
            with(:broadcast_date).equal_to(broadcast_date)
          when 'NE' then # と不一致
            without(:broadcast_date, broadcast_date)
          when 'LT' then # より小さい
            with(:broadcast_date).less_than(broadcast_date)
          when 'GT' then # より大きい
            with(:broadcast_date).greater_than(broadcast_date)
          when 'LE' then # 以下
            without(:broadcast_date).greater_than(broadcast_date)
          when 'GE' then # 以上
            without(:broadcast_date).less_than(broadcast_date)
          end
        end
        order_by(:score, :desc)
        paginate(:page=>1, :per_page=>@max_search_size)
      end
      return search.results
    end
    
    # 詳細検索（音楽）
    def dtl_music(cond_params)
      # 検索処理
      search = SourceMusic.search do
        # 番組名
        music_name = cond_params[:media_name]
        unless music_name.nil? then
          fulltext(music_name) do fields(:music_name) end
        end
        any_of do
          # 作詞家
          lyricist = cond_params[:reporter]
          unless lyricist.nil? then
            fulltext(lyricist) do fields(:lyricist) end
          end
          # 作曲家
          composer = cond_params[:reporter]
          unless composer.nil? then
            fulltext(composer) do fields(:composer) end
          end
        end
        order_by(:score, :desc)
        paginate(:page=>1, :per_page=>@max_search_size)
      end
      return search.results
    end
    
    # 詳細検索（動画）
    def dtl_movie(cond_params)
      # 検索処理
      search = SourceMovie.search do
        # 作品名
        title = cond_params[:media_name]
        unless title.nil? then
          fulltext(title) do fields(:title) end
        end
        any_of do
          # 制作
          production = cond_params[:reporter]
          unless production.nil? then
            fulltext(production) do fields(:production) end
          end
          # 販売
          sold_by = cond_params[:reporter]
          unless sold_by.nil? then
            fulltext(sold_by) do fields(:sold_by) end
          end
        end
        # 販売日
        release_date      = cond_params[:distribution_date]
        release_date_comp = cond_params[:distribution_date_comp]
        unless release_date.nil? then
          case release_date_comp
          when 'EQ' then # と一致
            with(:release_date).equal_to(release_date)
          when 'NE' then # と不一致
            without(:release_date, release_date)
          when 'LT' then # より小さい
            with(:release_date).less_than(release_date)
          when 'GT' then # より大きい
            with(:release_date).greater_than(release_date)
          when 'LE' then # 以下
            without(:release_date).greater_than(release_date)
          when 'GE' then # 以上
            without(:release_date).less_than(release_date)
          end
        end
        order_by(:score, :desc)
        paginate(:page=>1, :per_page=>@max_search_size)
      end
      return search.results
    end
    
    # 詳細検索（ゲーム）
    def dtl_game(cond_params)
      # 検索処理
      search = SourceGame.search do
        # 作品名
        title = cond_params[:media_name]
        unless title.nil? then
          fulltext(title) do fields(:title) end
        end
        # 販売
        sold_by = cond_params[:reporter]
        unless sold_by.nil? then
          fulltext(sold_by) do fields(:sold_by) end
        end
        # 販売日
        release_date      = cond_params[:distribution_date]
        release_date_comp = cond_params[:distribution_date_comp]
        unless release_date.nil? then
          case release_date_comp
          when 'EQ' then # と一致
            with(:release_date).equal_to(release_date)
          when 'NE' then # と不一致
            without(:release_date, release_date)
          when 'LT' then # より小さい
            with(:release_date).less_than(release_date)
          when 'GT' then # より大きい
            with(:release_date).greater_than(release_date)
          when 'LE' then # 以下
            without(:release_date).greater_than(release_date)
          when 'GE' then # 以上
            without(:release_date).less_than(release_date)
          end
        end
        order_by(:score, :desc)
        paginate(:page=>1, :per_page=>@max_search_size)
      end
      return search.results
    end
    
    # 詳細検索（ニュースサイト）
    def dtl_news_site(cond_params)
      # 検索処理
      search = SourceNewsSite.search do
        # サイト名
        site_name = cond_params[:media_name]
        unless site_name.nil? then
          fulltext(site_name) do fields(:site_name) end
        end
        # 掲載日時
        posted_date      = cond_params[:distribution_date]
        posted_date_comp = cond_params[:distribution_date_comp]
        unless posted_date.nil? then
          case posted_date_comp
          when 'EQ' then # と一致
            with(:posted_date).equal_to(posted_date)
          when 'NE' then # と不一致
            without(:posted_date, posted_date)
          when 'LT' then # より小さい
            with(:posted_date).less_than(posted_date)
          when 'GT' then # より大きい
            with(:posted_date).greater_than(posted_date)
          when 'LE' then # 以下
            without(:posted_date).greater_than(posted_date)
          when 'GE' then # 以上
            without(:posted_date).less_than(posted_date)
          end
        end
        # 記者
        reporter = cond_params[:reporter]
        unless reporter.nil? then
          fulltext(reporter) do fields(:reporter) end
        end
        # 記者肩書きID
        job_title_id = cond_params[:reporter_job_title_id]
        unless job_title_id.nil? then
          with(:job_title_id, job_title_id.to_i)
        end
        # 記者肩書き
        job_title = cond_params[:reporter_job_title]
        unless job_title.nil? then
          fulltext(job_title) do fields(:job_title) end
        end
        order_by(:score, :desc)
        paginate(:page=>1, :per_page=>@max_search_size)
      end
      return search.results
    end
    
    # 詳細検索（Twitter）
    def dtl_twitter(cond_params)
      # 検索処理
      search = SourceTwitter.search do
        # 投稿日時
        posted_date      = cond_params[:distribution_date]
        posted_date_comp = cond_params[:distribution_date_comp]
        unless posted_date.nil? then
          case posted_date_comp
          when 'EQ' then # と一致
            with(:posted_date).equal_to(posted_date)
          when 'NE' then # と不一致
            without(:posted_date, posted_date)
          when 'LT' then # より小さい
            with(:posted_date).less_than(posted_date)
          when 'GT' then # より大きい
            with(:posted_date).greater_than(posted_date)
          when 'LE' then # 以下
            without(:posted_date).greater_than(posted_date)
          when 'GE' then # 以上
            without(:posted_date).less_than(posted_date)
          end
        end
        # 投稿者
        posted_by = cond_params[:reporter]
        unless posted_by.nil? then
          fulltext(posted_by) do fields(:posted_by) end
        end
        # 投稿者肩書きID
        job_title_id = cond_params[:reporter_job_title_id]
        unless job_title_id.nil? then
          with(:job_title_id, job_title_id.to_i)
        end
        # 投稿者肩書き
        job_title = cond_params[:reporter_job_title]
        unless job_title.nil? then
          fulltext(job_title) do fields(:job_title) end
        end
        order_by(:score, :desc)
        paginate(:page=>1, :per_page=>@max_search_size)
      end
      return search.results
    end
    
    # 詳細検索（ブログ）
    def dtl_blog(cond_params)
      # 検索処理
      search = SourceBlog.search do
        # ブログ名
        blog_name = cond_params[:media_name]
        unless blog_name.nil? then
          fulltext(blog_name) do fields(:blog_name) end
        end
        # 投稿日時
        posted_date      = cond_params[:distribution_date]
        posted_date_comp = cond_params[:distribution_date_comp]
        unless posted_date.nil? then
          case posted_date_comp
          when 'EQ' then # と一致
            with(:posted_date).equal_to(posted_date)
          when 'NE' then # と不一致
            without(:posted_date, posted_date)
          when 'LT' then # より小さい
            with(:posted_date).less_than(posted_date)
          when 'GT' then # より大きい
            with(:posted_date).greater_than(posted_date)
          when 'LE' then # 以下
            without(:posted_date).greater_than(posted_date)
          when 'GE' then # 以上
            without(:posted_date).less_than(posted_date)
          end
        end
        # 投稿者
        posted_by = cond_params[:reporter]
        unless posted_by.nil? then
          fulltext(posted_by) do fields(:posted_by) end
        end
        # 投稿者肩書きID
        job_title_id = cond_params[:reporter_job_title_id]
        unless job_title_id.nil? then
          with(:job_title_id, job_title_id.to_i)
        end
        # 投稿者肩書き
        job_title = cond_params[:reporter_job_title]
        unless job_title.nil? then
          fulltext(job_title) do fields(:job_title) end
        end
        order_by(:score, :desc)
        paginate(:page=>1, :per_page=>@max_search_size)
      end
      return search.results
    end
    
    # 詳細検索（SNS）
    def dtl_sns(cond_params)
      # 検索処理
      search = SourceSns.search do
        # SNS名
        sns_name = cond_params[:media_name]
        unless sns_name.nil? then
          fulltext(sns_name) do fields(:sns_name, :sns_detail_name) end
        end
        # 投稿日時
        posted_date      = cond_params[:distribution_date]
        posted_date_comp = cond_params[:distribution_date_comp]
        unless posted_date.nil? then
          case posted_date_comp
          when 'EQ' then # と一致
            with(:posted_date).equal_to(posted_date)
          when 'NE' then # と不一致
            without(:posted_date, posted_date)
          when 'LT' then # より小さい
            with(:posted_date).less_than(posted_date)
          when 'GT' then # より大きい
            with(:posted_date).greater_than(posted_date)
          when 'LE' then # 以下
            without(:posted_date).greater_than(posted_date)
          when 'GE' then # 以上
            without(:posted_date).less_than(posted_date)
          end
        end
        # 投稿者
        posted_by = cond_params[:reporter]
        unless posted_by.nil? then
          fulltext(posted_by) do fields(:posted_by) end
        end
        # 投稿者肩書きID
        job_title_id = cond_params[:reporter_job_title_id]
        unless job_title_id.nil? then
          with(:job_title_id, job_title_id.to_i)
        end
        # 投稿者肩書き
        job_title = cond_params[:reporter_job_title]
        unless job_title.nil? then
          fulltext(job_title) do fields(:job_title) end
        end
        order_by(:score, :desc)
        paginate(:page=>1, :per_page=>@max_search_size)
      end
      return search.results
    end
    
    # 詳細検索（電子掲示板）
    def dtl_bbs(cond_params)
      # 検索処理
      search = SourceBbs.search do
        # 電子掲示板名
        bbs_name = cond_params[:media_name]
        unless bbs_name.nil? then
          fulltext(bbs_name) do fields(:bbs_name, :bbs_detail_name) end
        end
        # 投稿日時
        posted_date      = cond_params[:distribution_date]
        posted_date_comp = cond_params[:distribution_date_comp]
        unless posted_date.nil? then
          case posted_date_comp
          when 'EQ' then # と一致
            with(:posted_date).equal_to(posted_date)
          when 'NE' then # と不一致
            without(:posted_date, posted_date)
          when 'LT' then # より小さい
            with(:posted_date).less_than(posted_date)
          when 'GT' then # より大きい
            with(:posted_date).greater_than(posted_date)
          when 'LE' then # 以下
            without(:posted_date).greater_than(posted_date)
          when 'GE' then # 以上
            without(:posted_date).less_than(posted_date)
          end
        end
        # 投稿者
        posted_by = cond_params[:reporter]
        unless posted_by.nil? then
          fulltext(posted_by) do fields(:posted_by) end
        end
        order_by(:score, :desc)
        paginate(:page=>1, :per_page=>@max_search_size)
      end
      return search.results
    end
    
    # 詳細検索（その他サイト）
    def dtl_other_site(cond_params)
      # 検索処理
      search = SourceOtherSite.search do
        # サイト名
        site_name = cond_params[:media_name]
        unless site_name.nil? then
          fulltext(site_name) do fields(:site_name) end
        end
        # 掲載日時
        posted_date      = cond_params[:distribution_date]
        posted_date_comp = cond_params[:distribution_date_comp]
        unless posted_date.nil? then
          case posted_date_comp
          when 'EQ' then # と一致
            with(:posted_date).equal_to(posted_date)
          when 'NE' then # と不一致
            without(:posted_date, posted_date)
          when 'LT' then # より小さい
            with(:posted_date).less_than(posted_date)
          when 'GT' then # より大きい
            with(:posted_date).greater_than(posted_date)
          when 'LE' then # 以下
            without(:posted_date).greater_than(posted_date)
          when 'GE' then # 以上
            without(:posted_date).less_than(posted_date)
          end
        end
        # 掲載者
        posts_by = cond_params[:posts_by]
        unless posts_by.nil? then
          fulltext(posts_by) do fields(:posts_by) end
        end
        # 掲載者肩書きID
        job_title_id = cond_params[:reporter_job_title_id]
        unless job_title_id.nil? then
          with(:job_title_id, job_title_id.to_i)
        end
        # 掲載者肩書き
        job_title = cond_params[:reporter_job_title]
        unless job_title.nil? then
          fulltext(job_title) do fields(:job_title) end
        end
        order_by(:score, :desc)
        paginate(:page=>1, :per_page=>@max_search_size)
      end
      return search.results
    end
    
    # 詳細検索（その他）
    def dtl_other(cond_params)
      # 検索処理
      search = SourceOther.search do
        # 媒体名
        media_name = cond_params[:media_name]
        unless media_name.nil? then
          fulltext(media_name) do fields(:media_name) end
        end
        order_by(:score, :desc)
        paginate(:page=>1, :per_page=>@max_search_size)
      end
      return search.results
    end
  end
end