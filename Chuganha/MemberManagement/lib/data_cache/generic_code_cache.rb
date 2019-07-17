# -*- coding: utf-8 -*-
###############################################################################
# 汎用コード情報クラス
# 概要：業務共通のコード情報を保持するクラス
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/03/05 Nakanohito
# 更新日:
###############################################################################
require 'singleton'
require 'thread'
require 'yaml'

module DataCache
  class GenericCodeCache
    include Singleton
    # コンストラクタ
    def initialize
      # 排他制御オブジェクト生成
      @mutex = Mutex.new
      # コード情報ロードパス
      @load_path = Rails.root.join('config', 'business', 'generic_codes.yml').to_s
      # 言語ごとのコード情報リスト
      @locale_hash = nil
      # データをメモリに展開
      data_load
    end
    #########################################################################
    # public定義
    #########################################################################
    public
    # データロード処理
    def data_load
      # Code Information Load
      new_locale_hash = Hash.new
      code_yaml = YAML.load_file(@load_path)
      code_yaml.keys.each do |locale|
        code_info = code_yaml[locale]['business']['code_information']
        code_info_hash = Hash.new
        code_info.keys.each do |code_id|
          code_info_hash[code_id] = CodeInfo.new(code_id, code_info[code_id]).freeze
        end
        new_locale_hash[locale] = code_info_hash.freeze
      end
      @mutex.synchronize do
        @locale_hash = new_locale_hash
      end
    end
    
    # コード情報取得
    def code_info(code_id, locale=nil)
      locale ||= I18n.locale
      locale_top = @locale_hash[locale.to_s]
      return nil if locale_top.nil?
      return locale_top[code_id.to_s]
    end
    
    # コード名称取得
    def code_name(code_id, locale=nil)
      info = code_info(code_id, locale)
      return nil if info.nil?
      return info.code_name
    end
    
    # コード値配列取得
    def code_values(code_id, locale=nil)
      info = code_info(code_id, locale)
      return nil if info.nil?
      return info.values
    end
    
    # コード値のラベル配列取得
    def code_labels(code_id, locale=nil)
      info = code_info(code_id, locale)
      return nil if info.nil?
      return info.labels
    end
    
    #########################################################################
    # コード情報クラス
    #########################################################################
    class CodeInfo
      # コンスタント
      KEY_CODE_NAME  = 'code_name'
      KEY_CODE_VALUES = 'code_values'
      # アクセサー
      attr_reader :code_name, :code_hash
      # コンストラクタ
      def initialize(code_id, code_info)
        @code_id = code_id
        @code_name = code_info[KEY_CODE_NAME].freeze
        @code_hash = conv_str_hash(code_info[KEY_CODE_VALUES]).freeze
      end
      #######################################################################
      # public定義
      #######################################################################
      public
      # コード値名称配列取得
      def labels
        return @code_hash.values
      end
      # コード値名称配列取得
      def labels_hash
        return @code_hash.invert
      end
      # コード値配列取得
      def values
        return @code_hash.keys
      end
      #######################################################################
      # protected定義
      #######################################################################
      protected
      # キーと値の文字列変換処理
      def conv_str_hash(origin)
        new_hash = Hash.new
        origin.keys.each do |key|
          new_hash[key.to_s] = origin[key].to_s
        end
        return new_hash
      end
    end
  end
end