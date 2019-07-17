# -*- coding: utf-8 -*-
###############################################################################
# 形態素解析クラス
# 機能：文字列を形態素解析する
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/02/02 Nakanohito
# 更新日:
###############################################################################
require 'singleton'
require 'thread'
require 'igo-ruby'

module BizCommon
  # 形態素解析クラス
  class BizMorphemeParser
    include Singleton
    ###########################################################################
    # メソッド定義
    ###########################################################################
    # コンストラクタ
    def initialize
      # 排他制御オブジェクト生成
      @mutex = Mutex.new
      # 解析オブジェクト
      @tagger = Igo::Tagger.new('./ipadic')  # 解析用辞書のディレクトリを指定
      # 抽出対象（キーワード）
      @keyword_hash = {'名詞'=>['*'], '動詞'=>['*']}
      # 分割ポイント（文単位）
      @sentence_split_hash = {'記号'=>['空白','句点','読点'], '接続詞'=>['*']}
    end
    
    ###########################################################################
    # publicメソッド定義
    ###########################################################################
    public
    # キーワード抽出
    def keyword_extraction(sentence)
      # クリティカルセクションの実行
      @mutex.synchronize do
        # 動詞と名詞を抽出
        keywords = extraction(sentence, @keyword_hash)
        # 1文字のみのキーワードの除外
        keywords.delete_if do |word| word.nil? || word.length <= 1 end
        return keywords
      end
    end
    
    # 長文分割
    def split_sentence(sentence)
      # クリティカルセクションの実行
      @mutex.synchronize do
        return split(sentence, @sentence_split_hash)
      end
    end
    
    ###########################################################################
    # protectedメソッド定義
    ###########################################################################
    protected
    # 要素抽出
    def extraction(sentence, target_hash)
      word_list = Array.new
      result = @tagger.parse(sentence)
      result.each do |elm|
#Rails.logger.debug("#{elm.surface}　　#{elm.feature}　　#{elm.start}")
        feature_list = elm.feature.split(',')
        class_list = target_hash[feature_list[0]]
        next if class_list.nil?
        next if !class_list.include?('*') && !class_list.include?(feature_list[1])
        word_list.push(elm.surface)
      end
      return word_list
    end
    
    # 文章分割
    def split(sentence, split_hash, include_flg=false)
      sentence_list = Array.new
      result = @tagger.parse(sentence)
      wk_sentence = ''
      result.each do |elm|
        feature_list = elm.feature.split(',')
        class_list = split_hash[feature_list[0]]
        class_list ||= []
        if class_list.include?('*') || class_list.include?(feature_list[1]) then
          sentence_list.push(wk_sentence)
          wk_sentence = ''
          next unless include_flg
        end
        wk_sentence += elm.surface
      end
      sentence_list.push(wk_sentence) if wk_sentence.length > 0
      return sentence_list
    end
  end
end