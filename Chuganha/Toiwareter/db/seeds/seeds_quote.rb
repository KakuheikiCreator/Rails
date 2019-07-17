# -*- coding: utf-8 -*-
###############################################################################
# シードファイル
# 対象テーブル：引用
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/02/02 Nakanohito
# 更新日:
###############################################################################
require "csv"

module Seeds
  module SeedsQuote
    # 全データ削除
    def delete_all
      Quote.delete_all
      Comment.delete_all
    end
    module_function :delete_all
    
    # データ生成
    def create
      sentence_list = Array.new
      file_path = Rails.root + 'db/data/quote.txt'
      CSV.foreach(file_path) do |row| sentence_list.push(row[0]) end
      1000.times do |idx|
        quote = quote_ent(idx, sentence_list)
        quote.save!
        3.times do |idx2|
          comment = comment_ent(quote, idx2, sentence_list)
          comment.save!
        end
      end
    end
    module_function :create
    
    # 引用エンティティ生成
    def quote_ent(idx, sentence_list)
      ent = Quote.new
      ent.quote = sentence_list[idx % sentence_list.size()] + ' ' + idx.to_s
      ent.description = 'あいやー困ったあるよ'
      ent.source_id = 1
      ent.speaker = 'マスゴミ太郎'
      ent.speaker_job_title_id = 1
      ent.speaker_job_title = '内輪ネタ職人'
      ent.last_comment_seq_no = 3
      ent.registrant_id = (idx % 1000)
      ent.registered_member_id = 'MBR' + ent.registrant_id.to_s.rjust(7, '0')
      ent.registered_date = Time.now
      ent.update_id = (idx % 1000)
      ent.update_member_id = 'MBR' + ent.update_id.to_s.rjust(7, '0')
      ent.update_date = Time.now
      return ent
    end
    module_function :quote_ent
    
    # コメントエンティティ生成
    def comment_ent(quote_ent, idx, sentence_list)
      ent = Comment.new
      ent.quote_id = quote_ent.id
      ent.seq_no = idx
      ent.comment = sentence_list.sample.to_s
      ent.critic_id = rand(1000).to_i
      ent.critic_member_id = 'MBR' + ent.critic_id.to_s.rjust(7, '0')
      ent.criticism_date = Time.now
      return ent
    end
    module_function :comment_ent
  end
end
