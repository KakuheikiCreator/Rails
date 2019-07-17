# -*- coding: utf-8 -*-
###############################################################################
# 業務初期処理
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2011/08/28 Nakanohito
# 更新日:
###############################################################################
#require 'drb/drb'
# 業務設定
require 'biz_common/business_config'
#require 'biz_common/biz_rkv_initializer'
# RKVクライアント
#require 'rkvi/rkv_client'
# キャッシュデータ
#require 'data_cache/browser_cache'
#require 'data_cache/domain_cache'
#require 'data_cache/request_analysis_schedule_cache'
#require 'data_cache/request_analysis_result_cache'
#require 'data_cache/system_cache'

###############################################################################
# 設定情報ロード
###############################################################################
BizCommon::BusinessConfig.instance

Rails.logger.debug('Root:' + Rails.root.to_s)


###############################################################################
# RKVオブジェクトの初期化
###############################################################################
# ローカルサーバー停止
#DRb.stop_service
#rkv_client = Rkvi::RkvClient.instance
#rkv_client.svr_initializer = BizCommon::BizRkvInitializer.new
# RKVクライアント初期化
#rkv_client.refresh

###############################################################################
# キャッシュデータロード
###############################################################################
#DataCache::SystemCache.instance
#DataCache::DomainCache.instance
#DataCache::BrowserCache.instance
#DataCache::RequestAnalysisScheduleCache.instance
#DataCache::RequestAnalysisResultCache.instance
