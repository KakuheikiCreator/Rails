# -*- coding: utf-8 -*-
###############################################################################
# クラス：アプリケーションヘルパークラス
# 機能：規制リファラー一覧
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/08/06 Nakanohito
# 更新日:
###############################################################################
require 'biz_helpers/business_helper'

module BizHelpers
  module RegulationReferrerList
    class ListHelper < BizHelpers::BusinessHelper
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
      end
      #########################################################################
      # publicメソッド定義
      #########################################################################
      public
      # サブミットボタン生成
      def submit_button(value, action, opts={})
        opts[:type] = "button"
        opts[:value] = value
        opts[:onclick] = "submit_action(this, '" + action + "')"
        return tag("input", opts)
      end
      # サブミットボタン生成（削除）
      def delete_button(ent, opts={})
        opts[:type] = "button"
        opts[:value] = vt('item_names.delete')
        opts[:onclick] = "delete_action(this, '" + ent.id.to_s + "')"
        return tag("input", opts)
      end
      # システム選択コンボボックスオプション
      def system_select_options(selected=nil)
        system_data = DataCache::SystemCache.instance.system_data
        return options_from_ents(system_data, :id, [:system_name, :subsystem_name], selected, true)
      end
      # ソート項目選択コンボボックスオプション
      def item_select_options(selected=nil)
        system = System.human_attribute_name("system_name")
        referrer = RegulationReferrer.human_attribute_name("referrer")
        remarks = RegulationReferrer.human_attribute_name("remarks")
        label_hash = {
          system=>"system_id", referrer=>"referrer", remarks=>"remarks"
        }
        return options_for_select(label_hash, selected)
      end
    end
  end
end
