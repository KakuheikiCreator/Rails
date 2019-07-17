# -*- coding: utf-8 -*-
###############################################################################
# モデル：引用履歴
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/02/12 Nakanohito
# 更新日:
###############################################################################
require 'biz_search/source_search'
require 'data_cache/job_title_cache'
require 'data_cache/member_cache'

class QuoteHistory < ActiveRecord::Base
  include DataCache
  #############################################################################
  # 更新項目設定
  #############################################################################
  attr_accessible :quote_id, :seq_no, :quote, :description, :source_id,
                  :speaker, :speaker_job_title_id, :speaker_job_title, :last_comment_seq_no,
                  :registrant_id, :registered_member_id, :registered_date,
                  :update_id, :update_date, :update_member_id,
                  :delete_reason_id, :delete_reason_detail, :deleted_id, :delete_member_id,
                  :lock_version
  #############################################################################
  # リレーション設定
  #############################################################################
  # CommentDelete
  has_many :comment_delete
  
  #############################################################################
  # バリデーション定義
  #############################################################################
  validates :quote_id,
    :presence => true
  validates :seq_no,
    :presence => true
  validates :quote,
    :presence => true,
    :length => {:maximum => 400}
  validates :description,
    :allow_nil => true,
    :length => {:maximum => 2000}
  validates :source_id,
    :presence => true
  validates :speaker,
    :presence => true,
    :length => {:maximum => 60}
  validates :speaker_job_title,
    :allow_nil => true,
    :length => {:maximum => 40}
  validates :last_comment_seq_no,
    :presence => true
  validates :registrant_id,
    :presence => true
  validates :registered_member_id,
    :presence => true
  validates :registered_date,
    :presence => true
  validates :delete_reason_detail,
    :allow_nil => true,
    :length => {:maximum => 2000}
  
  #############################################################################
  # コールバック関数
  #############################################################################
  before_save :quote_history_save
  
  #############################################################################
  # public定義
  #############################################################################
  public
  # 登録者
  def registrant
    return DataCache::MemberCache.instance[self.registered_member_id]
  end
  
  # 発言者肩書き
  def speaker_job_title_name
    job_title = JobTitleCache.instance[self.speaker_job_title_id]
    return '' if job_title.nil?
    return job_title.job_title
  end
  
  #############################################################################
  # protected定義
  #############################################################################
  protected
  # 保存前処理
  def quote_history_save
    if self.deleted_id.nil? then
      # 最終訂正者情報更新
      if self.update_id.nil? then
        registered = MemberCache.instance[self.registered_member_id]
        registered.quote_correct_failure_cnt += 1
        registered.save!
      else
        correction = MemberCache.instance[self.update_member_id]
        correction.quote_correct_failure_cnt += 1
        correction.save!
      end
    else
      # 最終訂正者情報更新
      if self.update_id.nil? then
        registered = MemberCache.instance[self.registered_member_id]
        registered.quote_failure_cnt += 1
        registered.save!
      else
        correction = MemberCache.instance[self.update_member_id]
        correction.quote_failure_cnt += 1
        correction.save!
      end
      # 削除者情報更新
      expurgator = MemberCache.instance[self.delete_member_id]
      expurgator.quote_delete_cnt += 1
      expurgator.save!
    end
  end
end
