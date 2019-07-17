# -*- coding: utf-8 -*-
###############################################################################
# モデル：リクエスト解析結果
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2011/08/09 Nakanohito
# 更新日:
###############################################################################
require 'validators/ip_address_validator'

class RequestAnalysisResult < AccessManagementSuper
  include Validators
  #############################################################################
  # 更新項目設定
  #############################################################################
  attr_accessible :system_id, :request_analysis_schedule_id,
                  :received_year, :received_month, :received_day,
                  :received_hour, :received_minute, :received_second,
                  :function_id, :function_transition_no, :session_id, :client_id,
                  :browser_id, :browser_version_id, :accept_language, :referrer,
                  :domain_id, :proxy_host, :proxy_ip_address, :remote_host,
                  :ip_address, :request_count

  #############################################################################
  # リレーション設定
  #############################################################################
  # システム
  belongs_to :system
  # 機能
  belongs_to :function
  # ドメイン
  belongs_to :domain
  # ブラウザ
  belongs_to :browser
  # ブラウザバージョン
  belongs_to :browser_version
  # リクエスト解析スケジュール
  belongs_to :request_analysis_schedule
  
  #############################################################################
  # バリデーション定義
  #############################################################################
  validates :system_id,
    :presence => true
  validates :request_analysis_schedule_id,
    :presence => true
  validates :received_year,
    :allow_nil => true,
#    :numericality => {:only_integer => true, :greater_than => 2010}
    :numericality => {:only_integer => true, :greater_than => 0}
  validates :received_month,
    :allow_nil => true,
    :numericality => {:only_integer => true, :greater_than => 0, :less_than => 13}
  validates :received_day,
    :allow_nil => true,
    :numericality => {:only_integer => true, :greater_than => 0, :less_than => 32}
  validates :received_hour,
    :allow_nil => true,
    :numericality => {:only_integer => true, :greater_than => -1, :less_than => 24}
  validates :received_minute,
    :allow_nil => true,
    :numericality => {:only_integer => true, :greater_than => -1, :less_than => 60}
  validates :received_second,
    :allow_nil => true,
    :numericality => {:only_integer => true, :greater_than => -1, :less_than => 60}
  validates :function_transition_no,
    :allow_nil => true,
    :numericality => {:greater_than_or_equal_to => 0}
  validates :session_id,
    :allow_nil => true,
    :length => {:is => 32}
  validates :client_id,
    :allow_nil => true,
    :length => {:maximum => 255}
  validates :accept_language,
    :allow_nil => true,
    :length => {:maximum => 255}
  validates :referrer,
    :allow_nil => true,
    :length => {:maximum => 255}
  validates :proxy_host,
    :allow_nil => true,
    :length => {:maximum => 255}
  validates :proxy_ip_address,
    :allow_nil => true,
    :ip_address => true
  validates :remote_host,
    :allow_nil => true,
    :length => {:maximum => 255}
  validates :ip_address,
    :allow_nil => true,
    :ip_address => true
  validates :request_count,
    :presence => true,
    :allow_nil => true,
    :numericality => {:greater_than_or_equal_to => 0}
  #############################################################################
  # 検索条件定義
  #############################################################################
  scope :duplicate, lambda { |ent|
    where(ent.generate_duplicate_condition)
  }
  #############################################################################
  # publicメソッド定義
  #############################################################################
  public
  # 重複データ検索条件生成
  def generate_duplicate_condition
    return {:request_analysis_schedule_id => request_analysis_schedule_id,
            :received_year => received_year,
            :received_month => received_month,
            :received_day => received_day,
            :received_hour => received_hour,
            :received_minute => received_minute,
            :received_second => received_second,
            :function_id => function_id,
            :function_transition_no => function_transition_no,
            :session_id => session_id,
            :client_id => client_id,
            :browser_id => browser_id,
            :browser_version_id => browser_version_id,
            :accept_language => accept_language,
            :referrer => referrer,
            :domain_id => domain_id,
            :proxy_host => proxy_host,
            :proxy_ip_address => proxy_ip_address,
            :remote_host => remote_host,
            :ip_address => ip_address}
  end
end
