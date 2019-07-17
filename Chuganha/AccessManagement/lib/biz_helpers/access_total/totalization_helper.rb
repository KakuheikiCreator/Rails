# -*- coding: utf-8 -*-
###############################################################################
# クラス：アプリケーションヘルパークラス
# 機能：アクセス集計
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/10/07 Nakanohito
# 更新日:
###############################################################################
require 'biz_helpers/business_helper'

module BizHelpers
  module AccessTotal
    class TotalizationHelper < BizHelpers::BusinessHelper
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        @legend_list = 'ABCDEFGH'.split('')
      end
      #########################################################################
      # publicメソッド定義
      #########################################################################
      public
      # グラフデータ埋め込み
      def graph_data_tag(graph_data)
        # カラム名リスト
        col_names = [vt('item_names.counting_unit')]
        @params[:aggregation_period].to_i.times do |idx|
          col_names.push((idx + 1).to_s)
        end
        tag_list = [hidden_field_tag('graphs_col_names', col_names.join(','))]
        #　ラインデータ
        graph_data.each_with_index do |line_data, idx|
          legend = @legend_list[idx]
          tag_list.push(hidden_field_tag('graphs_data_' + legend, legend + ',' + line_data.join(',')))
        end
        return content_tag(:div, raw(tag_list.join("\n")), {:style=>"margin:0;padding:0;display:inline"})
      end
    end
  end
end
