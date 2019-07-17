# -*- coding: utf-8 -*-
###############################################################################
# 業務SQLクラス
# 概要：SQL生成のビジネスロジックを実装する
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/01/22 Nakanohito
# 更新日:
###############################################################################
require 'common/validation_chk_module'
require 'common/code_conv/encryption_setting'
require 'common/model/db_util_module'

module BizSearch
  class BusinessSQL
      include Common::ValidationChkModule
      include Common::CodeConv
      include Common::Model::DbUtilModule
    ###########################################################################
    # コンストラクタ
    ###########################################################################
    def initialize
      # バインド変数配列
      @bind_params = Array.new
      # SQL文
      @statement = nil
    end
    ###########################################################################
    # publicメソッド定義
    ###########################################################################
    public
    # SQLパラメータ生成
    def sql_params
      return @bind_params.dup.unshift(@statement)
    end
    
    # DB変数設定
    def set_db_variable(model_class=ActiveRecord::Base)
      setting = Common::CodeConv::EncryptionSetting.instance
      return model_class.connection.execute("SET @PW='" + setting.encryption_password + "';")
    end
    
    # DB変数クリア
    def clear_db_variable(model_class=ActiveRecord::Base)
      return model_class.connection.execute("SET @PW=NULL;")
    end
    
    ###########################################################################
    # protectedメソッド定義
    ###########################################################################
    protected
    # 項目復号化文生成
    def dec_item_statement(item)
      # 暗号化項目値開始位置
      enc_val_pos = EncryptionSetting.instance.encryption_salt_size + 1
      return 'SUBSTRING(CONVERT(AES_DECRYPT(' + item.to_s + ', @PW), CHAR), ' + enc_val_pos.to_s + ')'
    end
    
    # 復号化コンペア条件生成
    def dec_comp_statement(item, comp_cond='EQ')
      return comp_statement(dec_item_statement(item), comp_cond)
    end
    
    # 復号化マッチング条件生成
    def dec_match_statement(item, match_cond='E')
      return match_statement(dec_item_statement(item), match_cond)
    end
  end
end