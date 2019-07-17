# -*- coding: utf-8 -*-
###############################################################################
# モデル：コメント
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/01/13 Nakanohito
# 更新日:
###############################################################################
require 'data_cache/member_cache'

class Comment < ActiveRecord::Base
  #############################################################################
  # 更新項目設定
  #############################################################################
  attr_accessible :quote_id, :seq_no, :comment,
                  :critic_id, :critic_member_id, :criticism_date, :lock_version
  #############################################################################
  # リレーション設定
  #############################################################################
  # 引用
  belongs_to :quote
  # コメント通報
  has_many :comment_report
  
  #############################################################################
  # コールバック関数
  #############################################################################
  before_save :comment_save
  
  #############################################################################
  # Solr設定
  #############################################################################
  searchable do
    text :comment, :critic_member_id
    integer :quote_id
    integer :seq_no
    integer :critic_id
    time :criticism_date
  end
  
  #############################################################################
  # public定義
  #############################################################################
  public
  # 批評者
  def critic
    return DataCache::MemberCache.instance[self.critic_member_id]
  end
  
  # コメント削除生成
  def new_comment_delete
    ent = CommentDelete.new
    ent.quote_id         = self.quote_id
    ent.seq_no           = self.seq_no
    ent.comment          = self.comment
    ent.critic_id        = self.critic_id
    ent.critic_member_id = self.critic_member_id
    ent.criticism_date   = self.criticism_date
    return ent
  end
  
  #############################################################################
  # protected定義
  #############################################################################
  protected
  # 保存前処理
  def comment_save
    if self.new_record? then
      # 登録者情報更新
      critic_ent = self.critic
      critic_ent.comment_cnt += 1
      critic_ent.save!
    end
  end
end
