# -*- coding: utf-8 -*-
###############################################################################
# データキャッシュクラス
# モデル：システム
# 機能：データのキャッシュを行う
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2011/09/09 Nakanohito
# 更新日:
###############################################################################
require 'singleton'
require 'thread'
require 'common/validation_chk_module'

module DataCache
  # システムキャッシュクラス
  class SystemCache
    include Singleton
    include Common::ValidationChkModule
    # アクセサー定義
    attr_reader :system_data, :loaded_at
    ###########################################################################
    # メソッド定義
    ###########################################################################
    # コンストラクタ
    def initialize
      # 排他制御オブジェクト生成
      @mutex = Mutex.new
      # 業務設定
      @business_config = BizCommon::BusinessConfig.instance
      # システムデータ
      @system_data = nil
      # システムハッシュ
      @system_hash = Hash.new
      # キャッシュデータロード日時
      @loaded_at = nil
      # データをメモリに展開
      data_load
    end
    
    ###########################################################################
    # publicメソッド定義
    ###########################################################################
    public
    # データロード処理
    def data_load
      loaded_at = Time.now
      new_system_data = System.all
      # 不変オブジェクトにする
      new_system_data.each do |ent| ent.freeze end
      new_system_data.freeze
      new_system_hash = generate_system_hash(new_system_data)
      # クリティカルセクションの実行
      @mutex.synchronize do
        @loaded_at = loaded_at
        @system_data = new_system_data
        @system_hash = new_system_hash
      end
    end
    
    # システムの取得
    def get_system(system_name=nil, subsystem_name=nil)
      if system_name.nil? && subsystem_name.nil? then
        system_name = @business_config.system_name
        subsystem_name = @business_config.subsystem_name
      end
      subsystem_node = get_subsystem_node(system_name, subsystem_name)
      return nil if subsystem_node.nil?
      return subsystem_node.system
    end
    
    # 機能の取得
    def get_function(system_name, subsystem_name, function_path)
      subsystem_node = get_subsystem_node(system_name, subsystem_name)
      return nil if subsystem_node.nil?
      function_data = subsystem_node[function_path]
      if function_data.nil? && !blank?(function_path) then
        function_data = subsystem_node[function_path.gsub(/\/[^\/]*$/, "")]
      end
      return function_data
    end
    
    ###########################################################################
    # protectesdメソッド定義
    ###########################################################################
    protected
    # システムハッシュ生成
    def generate_system_hash(system_data)
      system_hash = Hash.new
      system_data.each do |info|
        system_hash[info.system_name] = Hash.new unless system_hash.key?(info.system_name)
        system_node = system_hash[info.system_name]
        system_node[info.subsystem_name] = SubsystemNode.new(info) unless system_node.key?(info.subsystem_name)
      end
      return system_hash
    end
    
    # サブシステムノードの取得
    def get_subsystem_node(system_name, subsystem_name)
      return nil unless @system_hash.key?(system_name)
      return @system_hash[system_name][subsystem_name]
    end
    
    ###########################################################################
    # サブシステムノードクラス
    ###########################################################################
    class SubsystemNode
      # アクセサー
      attr_reader :system 
      # コンストラクタ
      def initialize(system)
        # 排他制御オブジェクト生成
        @system = system
        @function_hash = generate_function_hash
      end
      
      #########################################################################
      # publicメソッド定義
      #########################################################################
      public
      # 配列参照の演算子を再定義
      def [](key_path)
        function_info = @function_hash[key_path]
        return function_info if !function_info.nil?
        @function_hash.each_value do |value|
          return value if value.function_path?(key_path)
        end
        return nil
      end
      
      # システムのIDの取得
      def id
        return @system.id
      end
      
      # システム名の取得
      def system_name
        return @system.system_name
      end
      
      # サブシステム名の取得
      def subsystem_name
        return @system.subsystem_name
      end
      
      #########################################################################
      # protectesdメソッド定義
      #########################################################################
      protected
      # 機能ハッシュ生成
      def generate_function_hash
        function_hash = Hash.new
        @system.function.each do |info|
          function_hash[info.function_path] = info
        end
        return function_hash
      end
    end
  end
end