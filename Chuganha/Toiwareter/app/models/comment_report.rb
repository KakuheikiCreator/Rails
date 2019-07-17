# -*- coding: utf-8 -*-
###############################################################################
# モデル：コメント通報
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/01/13 Nakanohito
# 更新日:
###############################################################################
require 'common/model/db_code_conv_module'
require 'data_cache/member_cache'

class CommentReport < ActiveRecord::Base
  include Common::Model::DbCodeConvModule
  #############################################################################
  # 更新項目設定
  #############################################################################
  attr_accessible :quote_id, :quote_history_id, :comment_id, :comment_delete_id, :seq_no,
                  :report_reason_id, :report_reason_detail, :whistleblower_id, 
                  :report_member_id, :report_date, :lock_version
  
  #############################################################################
  # リレーション設定
  #############################################################################
  # 引用
  belongs_to :quote
  # 引用履歴
  belongs_to :quote_history
  # コメント
  belongs_to :comment
  # コメント削除
  belongs_to :comment_delete
  
  #############################################################################
  # バリデーション定義
  #############################################################################
  validates :seq_no,
    :presence => true,
    :numericality => {:only_integer => true, :greater_than => 0}
  validates :report_reason_id,
    :presence => true
  validates :report_reason_detail,
    :presence => true,
    :length => {:maximum => 4000}
  validates :whistleblower_id,
    :presence => true
  validates :report_member_id,
    :presence => true
  validates :report_date,
    :presence => true
  
  #############################################################################
  # コールバック関数
  #############################################################################
  before_save :comment_report_save
  before_update :comment_report_update
  
  #############################################################################
  # public定義
  #############################################################################
  public
  # 通報者
  def whistleblower
    return DataCache::MemberCache.instance[self.report_member_id]
  end
  
  #############################################################################
  # protected定義
  #############################################################################
  protected
  # 保存前処理
  def comment_report_save
    if self.new_record? then
      # コメント登録者情報更新
      critic_ent = self.comment.critic
      critic_ent.were_reported_cnt += 1
      critic_ent.save!
      # 通報者情報更新
      whistleblower_ent = self.whistleblower
      whistleblower_ent.comment_report_cnt += 1
      whistleblower_ent.save!
    end
  end
  
  # 更新前処理
  def comment_report_update
    # 通報者情報更新
    if self.comment_delete_id_was.nil? && !self.comment_delete_id.nil? then
      whistleblower_ent = self.whistleblower
      whistleblower_ent.support_report_cnt += 1
      whistleblower_ent.save!
    end
  end
end
