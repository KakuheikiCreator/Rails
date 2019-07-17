# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：ビジネスアクションクラス
# コントローラー：AccessTotal::AccessTotalController
# アクション：totalization
# Copyright:: Copyright (c) 2011 仲務省
# 作成日:2012/10/18 Nakanohito
# 更新日:
###############################################################################

class TotalizationData
  # アクセサー定義
  attr_reader :referrer_list, :count_list
  #############################################################################
  # コンストラクタ
  #############################################################################
  def initialize
    @referrer_list = ['buf',
                      "http://www.yahoo.co.jp/",
                      "http://www.google.co.jp/",
                      "http://www.google.com/",
                      "http://www.fc2.com/",
                      "http://www.youtube.com/",
                      "http://www.facebook.com/",
                      "http://www.rakuten.co.jp/",
                      "http://www.amazon.co.jp/",
                      "http://www.livedoor.com/",
                      "http://www.ameblo.jp/",
                      "http://www.wikipedia.org/",
                      "http://www.twitter.com/",
                      "http://www.goo.ne.jp/",
                      "http://www.baidu.com/",
                      "http://www.nicovideo.jp/"]
    @count_list = ['buf', 1,2,4,8,16,32,64,128,256,512,1024,2048,4096,8192,16384]
  end
  
  #############################################################################
  # public定義
  #############################################################################
  public
  # マスタデータ生成
  def create_master
    20.times do |idx|
      type_no = idx + 1
      system_data(type_no)
      function_data(type_no)
      browser_data(type_no)
      browser_version_data(type_no)
      domain_data(type_no)
    end
  end
  
  # マスタデータ削除
  def delete_master
    Domain.delete_all
    BrowserVersion.delete_all
    Browser.delete_all
    Function.delete_all
    System.delete_all
  end
  
  # スケジュールデータ生成
  def create_schedule(date_time)
    RequestAnalysisSchedule.delete_all
    20.times do |idx|
      type_no = idx + 1
      schedule_data(date_time, type_no)
    end
  end
  
  # 解析結果データ生成
  def result_data(type_no, date_time)
    data = RequestAnalysisResult.new
#    data.system_id = type_no
    data.system_id = 1
    data.request_analysis_schedule_id = type_no
    data.received_year = date_time.year
    data.received_month = date_time.month
    data.received_day = date_time.day
    data.received_hour = date_time.hour
    data.received_minute = date_time.min
    data.received_second = date_time.sec
#    data.function_id = type_no
    data.function_id = 1
    data.function_transition_no = type_no
    data.login_id = 'Login_ID_' + type_no.to_s
    data.client_id = 'Client_ID_' + type_no.to_s
    data.browser_id = type_no
    data.browser_version_id = type_no
    data.accept_language = 'ja_' + type_no.to_s
    data.referrer = @referrer_list[type_no.to_i]
    data.domain_id = type_no
    data.proxy_host = 'proxy' + type_no.to_s + '.com'
    data.proxy_ip_address = '192.168.100.' + type_no.to_s
    data.remote_host = 'client' + type_no.to_s + '.com'
    data.ip_address = '192.168.200.' + type_no.to_s
    data.request_count = @count_list[type_no.to_i]
    return data
  end
  
  #############################################################################
  # protected定義
  #############################################################################
  protected
  
  # システムデータ生成
  def system_data(type_no)
    System.create do |data|
      data.id = type_no
      data.system_name = 'System Name ' + type_no.to_s
      data.subsystem_name = 'SubSystem Name ' + type_no.to_s
    end
  end
  
  # 機能データ生成
  def function_data(type_no)
    Function.create do |data|
      data.id = type_no
      data.system_id = type_no
      data.function_path = 'Function Path ' + type_no.to_s
      data.function_name = 'Function Name ' + type_no.to_s
    end
  end
  
  # ブラウザデータ生成
  def browser_data(type_no)
    Browser.create do |data|
      data.id = type_no
      data.browser_name = 'Browser Name ' + type_no.to_s
    end
  end
  
  # ブラウザデータ生成
  def browser_version_data(type_no)
    BrowserVersion.create do |data|
      data.id = type_no
      data.browser_id = type_no
      data.browser_version = 'Browser Version ' + type_no.to_s
    end
  end
  
  # ドメインデータ生成
  def domain_data(type_no)
    Domain.create do |data|
      data.id = type_no
      data.domain_name = 'domain' + type_no.to_s + '.jp'
      data.domain_class = 0
      data.remarks = 'Domain Remarks ' + type_no.to_s
    end
  end
  
  # ドメインデータ生成
  def schedule_data(date_time, type_no)
    RequestAnalysisSchedule.create do |data|
      data.id = type_no
      data.gets_start_date = date_time
      data.system_id = type_no
      data.gs_received_year = true
      data.gs_received_month = true
      data.gs_received_day = true
      data.gs_received_hour = true
      data.gs_received_minute = true
      data.gs_received_second = true
      data.gs_function_id = true
      data.gs_function_transition_no = true
      data.gs_login_id = true
      data.gs_client_id = true
      data.gs_browser_id = true
      data.gs_browser_version_id = true
      data.gs_accept_language = true
      data.gs_referrer = true
      data.gs_domain_id = true
      data.gs_proxy_host = true
      data.gs_proxy_ip_address = true
      data.gs_remote_host = true
      data.gs_ip_address = true
    end
  end
end