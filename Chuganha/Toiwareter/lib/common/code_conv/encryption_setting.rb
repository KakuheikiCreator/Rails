# -*- coding: utf-8 -*-
###############################################################################
# 暗号設定情報クラス
# Copyright:: Copyright (c) 2011 仲務省
# 作成日:2011/06/29 Nakanohito
# 更新日:
###############################################################################
require 'singleton'
require 'yaml'
require 'common/validation_chk_module'

module Common::CodeConv
  class EncryptionSetting
    include Singleton
    include Common::ValidationChkModule
    # アクセスメソッド定義
    attr_reader :encryption_algorithm, :encryption_password, :encryption_salt_size, :hash_salt_size
    ###########################################################################
    # メソッド定義
    ###########################################################################
    # 初期処理
    def initialize
      # 暗号設定ファイルパスの取得
      filepath = Rails.root + 'config/encryption.yml'
      begin
        # 暗号設定ファイルの読み込み
        setting_info = YAML.load_file(filepath)
        # パラメータの取得
        @encryption_algorithm = setting_info['encryption_algorithm'].freeze     # 暗号化アルゴリズム
        @encryption_password  = setting_info['encryption_password'].freeze      # 暗号化キー
        @encryption_password  = ENV['ENC_KEY'] if blank?(@encryption_password)  # 暗号化キー（環境変数から取得）
        @encryption_salt_size = setting_info['encryption_salt_size'].freeze     # 暗号化用ソルトサイズ
        @hash_salt_size       = setting_info['hash_salt_size'].freeze           # ハッシュ用ソルトサイズ
        # パラメータチェック
        error_msg = "Encryption Setting File Parameter Error"
        raise error_msg + '(encryption_algorithm)' if blank?(@encryption_algorithm)
        raise error_msg + '(encryption_password)'  if blank?(@encryption_password)
        raise error_msg + '(encryption_salt_size)' if blank?(@encryption_salt_size)
        raise error_msg + '(hash_salt_size)'       if blank?(@hash_salt_size)
        # 暗号設定ファイルの削除
#        File.delete(filepath)
      rescue Errno::ENOENT
        raise 'Encryption Setting File Open Error'
      rescue Errno::EACCES
        raise 'Encryption Setting File Permissions Error'
      end
      # 暗号設定情報初期化終了メッセージ
      Rails.logger.info('EncryptionSetting initialized')
    end
  end  
end
