# -*- coding: utf-8 -*-
###############################################################################
# シードファイル
# 対象テーブル：通報理由
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/02/14 Nakanohito
# 更新日:
###############################################################################
require "csv"

module Seeds
  module SeedsReportReason
    # 全データ削除
    def delete_all
      ReportReason.delete_all
    end
    module_function :delete_all
    # データ生成
    def create
      file_path = Rails.root + 'db/data/report_reason.txt'
      id_val = 1
      CSV.foreach(file_path) do |row|
        ReportReason.create do |ent|
          ent.id = row[0].to_i;
          ent.report_reason = row[1];
        end
      end
    end
    module_function :create
  end
end