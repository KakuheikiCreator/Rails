###############################################################################
# マイグレーションヘルパーモジュール
# Copyright:: Copyright (c) 2011 仲務省
# 作成日:2011/07/26 Nakanohito
# 更新日:
###############################################################################
module Models
  module MigrationHelperModule
    # 外部キー作成メソッド.
    # migrationで外部キーを実行する場合のSQLを見えないようにして、migrationファイルの可視性アップを狙う.
    def foreign_key(child_table, child_column, parents_table, parents_column)
      constraint_name = "fk_#{child_table}_#{parents_table}"
      execute "alter table #{child_table} add constraint #{constraint_name} " +
      "foreign key (#{column_str(child_column)}) " +
      "references #{parents_table}(#{column_str(parents_column)})"
    end
    
    # 外部キー削除メソッド.
    # migrationで外部キーを実行する場合のSQLを見えないようにして、migrationファイルの可視性アップを狙う.
    def drop_foreign_key(child_table, parents_table)
      constraint_name = "fk_#{child_table}_#{parents_table}"
      execute "alter table `#{child_table}` drop foreign key #{constraint_name}"
    end

    # カラムの記述を生成
    def column_str(column)
      if column.class.to_s == "Array" then
        col_names = ""
        column.each do |col_name|
          col_names = col_names + col_name + ","
        end
        return col_names.sub(/,$/,"")
      end
      return column
    end
  end
end