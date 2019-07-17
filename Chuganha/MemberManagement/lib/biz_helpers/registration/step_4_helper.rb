# -*- coding: utf-8 -*-
###############################################################################
# 業務ヘルパークラス
# 概要：入力された会員情報の確認画面表示アクション
# コントローラー：Registration::RegistrationController
# アクション：step_4
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/11/29 Nakanohito
# 更新日:
###############################################################################
require 'biz_helpers/business_helper'
require 'data_cache/gender_cache'
require 'data_cache/country_cache'
require 'data_cache/language_cache'

module BizHelpers
  module Registration
    class Step4Helper < BizHelpers::BusinessHelper
      include DataCache
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
      end
      
      #########################################################################
      # public定義
      #########################################################################
      public
      # 性別取得
      def gender(gender_cls)
        gender_data = GenderCache.instance[gender_cls]
        return '' if gender_data.nil?
        return gender_data.gender
      end
      
      # 国名取得
      def country_name(country_name_cd)
        country_data = CountryCache.instance[country_name_cd]
        return '' if country_data.nil?
        return country_data.country_name
      end
      
      # 言語名取得
      def lang_name(lang_name_cd)
        language_data = LanguageCache.instance[lang_name_cd]
        return '' if language_data.nil?
        return language_data.lang_name
      end
    end
  end
end
