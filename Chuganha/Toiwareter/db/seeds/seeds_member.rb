# -*- coding: utf-8 -*-
###############################################################################
# シードファイル
# 対象テーブル：会員
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/01/06 Nakanohito
# 更新日:
###############################################################################

module Seeds
  module SeedsMember
    # 全データ削除
    def delete_all
      Member.delete_all
    end
    module_function :delete_all
    
    # データ生成
    def create
      1000.times do |idx|
        member = member_ent(idx)
        member.save!
      end
    end
    module_function :create
    
    # 会員エンティティ生成
    def member_ent(idx)
      authority_hash = {0=>'GEN', 1=>'ADM'}
      gender_hash = {0=>'M', 1=>'F'}
      ent = Member.new
      ent.set_enc_value(:enc_open_id, 'http://www.abc.com/' + idx.to_s)
      ent.member_id = 'MBR' + idx.to_s.rjust(7, '0')
      ent.member_state_id = ((idx + 1) % 3) + 1
      ent.authority_id = ((idx + 1) % 2) + 1
      ent.set_enc_value(:enc_nickname, 'Nickname' + idx.to_s)
      ent.set_enc_value(:enc_email, 'meru.' + idx.to_s + '@naka.com')
      ent.join_date = Time.zone.now
      ent.last_login_date = Time.zone.now - 1.hour
      ent.ineligibility_date = nil
      ent.login_cnt = idx + 1000
      ent.quote_cnt = idx
      ent.quote_failure_cnt = idx + 100
      ent.quote_correct_cnt = idx + 200
      ent.quote_correct_failure_cnt = idx + 300
      ent.quote_delete_cnt  = idx + 400
      ent.comment_cnt = idx + 500
      ent.comment_failure_cnt = idx + 600
      ent.comment_report_cnt  = idx + 700
      ent.were_reported_cnt   = idx + 800
      ent.support_report_cnt  = idx + 900
      return ent
    end
    module_function :member_ent
  end
end
