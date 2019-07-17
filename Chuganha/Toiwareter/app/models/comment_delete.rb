# -*- coding: utf-8 -*-
###############################################################################
# モデル：コメント削除
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/02/17 Nakanohito
# 更新日:
###############################################################################
require 'data_cache/member_cache'

class CommentDelete < ActiveRecord::Base
  #############################################################################
  # 更新項目設定
  #############################################################################
  attr_accessible :quote_id, :quote_history_id, :seq_no, :comment,
                  :critic_id, :critic_member_id, :criticism_date,
                  :delete_reason_id, :delete_reason_detail,
                  :deleted_id, :delete_member_id, :lock_version

  #############################################################################
  # リレーション設定
  #############################################################################
  # 引用
  belongs_to :quote
  # 引用履歴
  belongs_to :quote_history
  # コメント通報
  has_many :comment_report
  
  #############################################################################
  # バリデーション定義
  #############################################################################
  validates :seq_no,
    :presence => true,
    :numericality => {:only_integer=>true, :greater_than => 0}
  validates :comment,
    :presence => true,
    :length => {:maximum => 4000}
  validates :critic_id,
    :presence => true
  validates :critic_member_id,
    :presence => true
  validates :criticism_date,
    :presence => true
  validates :delete_reason_id,
    :presence => true
  validates :delete_reason_detail,
    :presence => true,
    :length => {:maximum => 2000}
  validates :deleted_id,
    :presence => true
  validates :delete_member_id,
    :presence => true
  
  #############################################################################
  # コールバック関数
  #############################################################################
  before_save :comment_delete_save
  
  #############################################################################
  # public定義
  #############################################################################
  public
  # 批評者
  def critic
    return DataCache::MemberCache.instance[self.critic_member_id]
  end
  
  #############################################################################
  # protected定義
  #############################################################################
  protected
  # 保存前処理
  def comment_delete_save
    if self.new_record? then
      # 登録者情報更新
      critic_ent = self.critic
      critic_ent.comment_failure_cnt += 1
      critic_ent.save!
    end
  end
end
