# -*- coding: utf-8 -*-
###############################################################################
# 業務バリデーションチェックモジュール
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/01/29 Nakanohito
# 更新日:
###############################################################################

module BizCommon
  module BizValidationModule
    ###########################################################################
    # protectedメソッド定義
    ###########################################################################
    protected
    ###########################################################################
    # 定数定義
    ###########################################################################
    REG_ISBN_10        = /^\d*\-\d*\-\d*\-[0-9X]{1}$/      # 正規表現（ISBN-10）
    REG_ISBN_13        = /^(978|979)\-\d*\-\d*\-\d*\-\d$/  # 正規表現（ISBN-13）
    REG_MAGAZINE_CD_5  = /^\d{5}\-\d{1,2}(\/\d{1,2})?$/    # 正規表現（雑誌コード）
    REG_MAGAZINE_CD_13 = /^\d{13}$/        # 正規表現（共通雑誌コード ）
    REG_MAGAZINE_CD_18 = /^\d{13}\-\d{5}$/ # 正規表現（定期刊行物コード ）
    REG_JASRAC_CD      = /^[0-9A-Z]{3}\-\d{4}\-\d{1}$/      # 正規表現（JASRAC_CD）
    REG_ISWC           = /^T\-(\d{3}\.){2}\d{3}\-\d{1}$/    # 正規表現（ISWC）
    
    # ISBNチェック
    def isbn?(val)
      return false unless String === val
      return true if (REG_ISBN_10 =~ val) != nil
      return (REG_ISBN_13 =~ val) != nil
    end
    module_function :isbn?

    # 雑誌コード
    def magazine_cd?(val)
      return false unless String === val
      return true if (REG_MAGAZINE_CD_5 =~ val) != nil
      return true if (REG_MAGAZINE_CD_13 =~ val) != nil
      return (REG_MAGAZINE_CD_18 =~ val) != nil
    end
    module_function :magazine_cd?

    # JASRACコードチェック
    def jasrac_cd?(val)
      return false unless String === val
      return (REG_JASRAC_CD =~ val) != nil
    end
    module_function :jasrac_cd?

    # ISWCコードチェック
    def iswc?(val)
      return false unless String === val
      return (REG_ISWC =~ val) != nil
    end
    module_function :iswc?
  end
end