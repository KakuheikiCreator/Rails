# -*- coding: utf-8 -*-
###############################################################################
# モデル：リクエスト解析スケジュール
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/02/27 Nakanohito
# 更新日:
###############################################################################
require 'common/model/where_clause'
require 'common/validation_chk_module'
require 'validators/any_exists_validator'

class RequestAnalysisSchedule < AccessManagementSuper
  extend  Common::ValidationChkModule
  include Common::Model
  include Validators
  #############################################################################
  # 更新項目設定
  #############################################################################
  attr_accessible :gets_start_date, :system_id,
                  :gs_received_year, :gs_received_month, :gs_received_day,
                  :gs_received_hour, :gs_received_minute, :gs_received_second,
                  :gs_function_id, :gs_function_transition_no, :gs_session_id, :gs_client_id,
                  :gs_browser_id, :gs_browser_version_id, :gs_accept_language,
                  :gs_referrer, :gs_domain_id, :gs_proxy_host, :gs_proxy_ip_address,
                  :gs_remote_host, :gs_ip_address
  
  #############################################################################
  # リレーション設定
  #############################################################################
  # システム
  belongs_to :system
  # リクエスト解析結果
  has_many :request_analysis_result, :dependent=>:delete_all
  
  #############################################################################
  # バリデーション定義
  #############################################################################
  validates :gets_start_date,
    :presence => true
  validates :system_id,
    :presence => true
  
  #############################################################################
  # 検索条件定義
  #############################################################################
  # リスト検索
  scope :find_list, lambda { |cond_hash|
    where(find_condition_list(cond_hash))
  }
  
  # 重複データ検索
  scope :duplicate, lambda { |ent|
    where(ent.generate_duplicate_condition)
  }
  
  #############################################################################
  # public定義
  #############################################################################
  public
  # 検索条件リスト
  def self.find_condition_list(cond_hash)
    cond = WhereClause.new
    # システムID
    system_id = cond_hash[:system_id]
    if !blank?(system_id) && numeric?(system_id.to_s) then
      cond.where(:system_id=>system_id.to_i)
    end
    # 取得開始日時（From）
    from_datetime = cond_hash[:from_datetime]
    cond.where("gets_start_date >= ?", from_datetime) unless blank?(from_datetime)
    # 取得開始日時（To）
    to_datetime = cond_hash[:to_datetime]
    cond.where("gets_start_date <= ?", to_datetime) unless blank?(to_datetime)
    # WHERE句の生成
    return cond.to_condition
  end
  
  # 重複データ検索条件生成
  def generate_duplicate_condition
    return {:system_id=>system_id,
            :gets_start_date=>gets_start_date}
  end
  
end