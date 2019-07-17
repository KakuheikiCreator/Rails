# -*- coding: utf-8 -*-
###############################################################################
# ロケール情報設定フィルタ
# 実行の前提：なし
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2012/01/23 Nakanohito
# 更新日:
###############################################################################
require 'common/net_util_module'
require 'tzinfo/country'

module Filter
  module SetLocale
    class SetLocaleFilter
      include Common::NetUtilModule
      #########################################################################
      # publicメソッド定義
      #########################################################################
      public
      # フィルタ処理
      def filter(controller)
        # 言語コード
        controller.logger.debug('SetLocaleFilter Execute!!!')
        locale = ex_lang_code(controller.request.headers['Accept-Language'])
        if locale.nil? || !I18n.available_locales.include?(locale.to_sym) then
          locale = I18n.default_locale
        end
        I18n.locale = locale.to_sym
      end
    end
  end
end