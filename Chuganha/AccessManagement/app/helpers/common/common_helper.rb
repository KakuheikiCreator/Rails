# -*- coding: utf-8 -*-
###############################################################################
# 機能：共通
# 画面：各画面共通
# クラス：ビューヘルパー
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/08/08 Nakanohito
# 更新日:
###############################################################################
module Common::CommonHelper
  # システム選択コンボボックスオプション
  def system_select_options(selected=nil)
    system_data = DataCache::SystemCache.instance.system_data
    return options_from_ents(system_data, :id, [:system_name, :subsystem_name], selected, true)
  end
  
  # ブラウザ選択コンボボックスオプション
  def browser_select_options(selected=nil)
    browser_data = DataCache::BrowserCache.instance.browser_data
    return options_from_ents(browser_data, :id, :browser_name, selected, true)
  end
end
