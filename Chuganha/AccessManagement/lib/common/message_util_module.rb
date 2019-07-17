# -*- coding: utf-8 -*-
###############################################################################
# メッセージユーティリティモジュール
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/01/29 Nakanohito
# 更新日:
###############################################################################
module Common
  module MessageUtilModule
    protected
    ###########################################################################
    # メソッド定義
    ###########################################################################
    # エラーメッセージ生成
    def error_msg(attr, msg, msg_option=Hash.new)
      option ={:attribute=> I18n.t(attr)}
      option[:message] = I18n.t('errors.messages.' + msg, msg_option)
      return I18n.t('errors.format', option)
    rescue StandardError => ex
      return 'message generation error!!!'
    end
  end
end