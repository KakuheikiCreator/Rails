# -*- coding: utf-8 -*-
###############################################################################
# 出所アクション生成クラス
# 機能：出所アクションの生成を行う
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/02/25 Nakanohito
# 更新日:
###############################################################################
require 'singleton'
require 'common/validation_chk_module'
require 'biz_actions/quote_source/form_bbs_action'
require 'biz_actions/quote_source/form_blog_action'
require 'biz_actions/quote_source/form_book_action'
require 'biz_actions/quote_source/form_game_action'
require 'biz_actions/quote_source/form_magazine_action'
require 'biz_actions/quote_source/form_movie_action'
require 'biz_actions/quote_source/form_music_action'
require 'biz_actions/quote_source/form_news_site_action'
require 'biz_actions/quote_source/form_newspaper_action'
require 'biz_actions/quote_source/form_other_site_action'
require 'biz_actions/quote_source/form_other_action'
require 'biz_actions/quote_source/form_radio_action'
require 'biz_actions/quote_source/form_sns_action'
require 'biz_actions/quote_source/form_tv_action'
require 'biz_actions/quote_source/form_twitter_action'
require 'biz_actions/quote_source/source_factory'

module BizActions
  module QuoteSource
    # 出所アクション生成クラス
    class SourceFactory
      include Singleton
      include Common::ValidationChkModule
      #########################################################################
      # メソッド定義
      #########################################################################
      # コンストラクタ
      def initialize
      end
      
      #########################################################################
      # publicメソッド定義
      #########################################################################
      public
      # 出所オブジェクト生成
      def create_action(controller, source_id)
        return nil unless numeric?(source_id.to_s)
        case source_id.to_i
        when 1 then # 新聞
          return FormNewspaperAction.new(controller)
        when 2 then # 雑誌
          return FormMagazineAction.new(controller)
        when 3 then # 書籍
          return FormBookAction.new(controller)
        when 4 then # テレビ
          return FormTvAction.new(controller)
        when 5 then # ラジオ
          return FormRadioAction.new(controller)
        when 6 then # 音楽
          return FormMusicAction.new(controller)
        when 7 then # 動画
          return FormMovieAction.new(controller)
        when 8 then # ゲーム
          return FormGameAction.new(controller)
        when 9 then # ニュースサイト
          return FormNewsSiteAction.new(controller)
        when 10 then # Twitter
          return FormTwitterAction.new(controller)
        when 11 then # ブログ
          return FormBlogAction.new(controller)
        when 12 then # SNS
          return FormSnsAction.new(controller)
        when 13 then # 電子掲示板
          return FormBbsAction.new(controller)
        when 14 then # その他サイト
          return FormOtherSiteAction.new(controller)
        when 15 then # その他
          return FormOtherAction.new(controller)
        else
          return nil
        end
      end
    end
  end
end