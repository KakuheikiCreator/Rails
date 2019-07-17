# -*- coding: utf-8 -*-
###############################################################################
# データベースコード変換モジュール
# 概要：変換コード値を持つデータモデルに追加して使用
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2012/11/26 Nakanohito
# 更新日:
###############################################################################
require 'openssl'
require 'common/code_conv/code_converter'
require 'common/code_conv/encryption_setting'

module Common
  module Model
    module DbCodeConvModule
      #########################################################################
      # publicメソッド定義
      #########################################################################
      public
      # デコード値を取得
      def dec_value(item_name)
        enc_value = attributes[item_name.to_s]
        return nil if enc_value.nil?
        begin
          return Common::CodeConv::CodeConverter.instance.decryption(enc_value)
        rescue OpenSSL::OpenSSLError
          return nil
        end
      end
      
      # デコード値をハッシュ化した値を取得
      def dec_hash_value(item_name, salt)
        enc_value = attributes[item_name.to_s]
        return nil if enc_value.nil?
        begin
          converter = Common::CodeConv::CodeConverter.instance
          dec_value = converter.decryption(enc_value)
          return converter.hash(dec_value, salt)
        rescue OpenSSL::OpenSSLError
          return nil
        end
      end
      
      # エンコード値設定
      def set_enc_value(item_name, value)
        return if item_name.nil? || !(String === value)
        return unless attributes.has_key?(item_name.to_s)
        begin
          converter = Common::CodeConv::CodeConverter.instance
          __send__(item_name.to_s + '=', converter.encryption(value))
        rescue OpenSSL::OpenSSLError
          return
        end
      end
      
      # ハッシュ値設定
      def set_hash_value(item_name, value, salt=nil)
        return if item_name.nil? || !(String === value)
        return unless attributes.has_key?(item_name.to_s)
        begin
          converter = Common::CodeConv::CodeConverter.instance
          __send__(item_name.to_s + '=', converter.hash(value.to_s, salt))
        rescue OpenSSL::OpenSSLError
          return
        end
      end
    end
  end
end