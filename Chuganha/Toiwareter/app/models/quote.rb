# -*- coding: utf-8 -*-
###############################################################################
# モデル：引用
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/01/13 Nakanohito
# 更新日:
###############################################################################
require 'biz_search/source_search'
require 'data_cache/job_title_cache'
require 'data_cache/member_cache'

class Quote < ActiveRecord::Base
  include DataCache
  #############################################################################
  # 更新項目設定
  #############################################################################
  attr_accessible :quote, :description, :source_id,
                  :speaker, :speaker_job_title_id, :speaker_job_title,
                  :last_history_seq_no, :last_comment_seq_no,
                  :registrant_id, :registered_member_id, :registered_date,
                  :update_id, :update_member_id, :update_date, :lock_version
  
  #############################################################################
  # リレーション設定
  #############################################################################
  # Comment
  has_many :comment, :dependent=>:delete_all
  # CommentDelete
  has_many :comment_delete
  
  #############################################################################
  # バリデーション定義
  #############################################################################
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
  
  #############################################################################
  # コールバック関数
  #############################################################################
  before_save :quote_save
  before_update :quote_update
  before_destroy :quote_destroy
  
  #############################################################################
  # Solr設定
  #############################################################################
  searchable do
    text :quote, :description, :speaker, :speaker_job_title_name, :speaker_job_title,
         :registered_member_id, :update_member_id
    integer :source_id
    integer :speaker_job_title_id
    integer :registrant_id
    integer :update_id
    time :registered_date
    time :update_date
  end
  
  #############################################################################
  # public定義
  #############################################################################
  public
  # Source
  def source
    return BizSearch::SourceSearch.instance.find_source(self.source_id, self.id)
  end
  
  # 登録者
  def registrant
    return DataCache::MemberCache.instance[self.registered_member_id]
  end
  
  # 訂正者
  def updated
    return DataCache::MemberCache.instance[self.update_member_id]
  end
  
  # 発言者肩書き
  def speaker_job_title_name
    job_title = JobTitleCache.instance[self.speaker_job_title_id]
    return '' if job_title.nil?
    return job_title.job_title
  end
  
  # 引用履歴生成
  def new_history
    ent = QuoteHistory.new
    ent.quote_id    = self.id
    ent.quote       = self.quote
    ent.description = self.description
    ent.source_id   = self.source_id
    ent.speaker              = self.speaker
    ent.speaker_job_title_id = self.speaker_job_title_id
    ent.speaker_job_title    = self.speaker_job_title
    ent.last_comment_seq_no  = self.last_comment_seq_no
    ent.registrant_id        = self.registrant_id
    ent.registered_member_id = self.registered_member_id
    ent.registered_date      = self.registered_date
    ent.update_id        = self.update_id
    ent.update_member_id = self.update_member_id
    ent.update_date      = self.update_date
    return ent
  end
  
  #############################################################################
  # protected定義
  #############################################################################
  protected
  # 保存前処理
  def quote_save
    if self.new_record? then
      unless self.registrant_id.nil? then
        # 登録者情報更新
        registrant = MemberCache.instance[self.registered_member_id]
        registrant.quote_cnt += 1
        registrant.save
      end
    end
  end
  
  # 更新前処理
  def quote_update
Rails.logger.debug('Exec:before_update')
    unless self.update_id.nil? then
      # 訂正者情報更新
      correction = MemberCache.instance[self.update_member_id]
      correction.quote_correct_cnt += 1
      correction.save
    end
  end
  
  # 削除前処理
  def quote_destroy
    # 出所
    self.source.destroy
  end
end
