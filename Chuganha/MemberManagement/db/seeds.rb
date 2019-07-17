# -*- coding: utf-8 -*-
###############################################################################
# シードファイル
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/01/30 Nakanohito
# 更新日:
###############################################################################
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# アクセス管理
require Rails.root + 'db/seeds/seeds_system'
require Rails.root + 'db/seeds/seeds_function'
require Rails.root + 'db/seeds/seeds_request_analysis_schedule'
require Rails.root + 'db/seeds/seeds_regulation_cookie'
# 会員管理
require Rails.root + 'db/seeds/seeds_member_state'
require Rails.root + 'db/seeds/seeds_authority'
require Rails.root + 'db/seeds/seeds_gender'
require Rails.root + 'db/seeds/seeds_country'
require Rails.root + 'db/seeds/seeds_language'
require Rails.root + 'db/seeds/seeds_timezone'
require Rails.root + 'db/seeds/seeds_mobile_carrier'
require Rails.root + 'db/seeds/seeds_withdrawal_reason'
require Rails.root + 'db/seeds/seeds_person_withdrawal_state'
require Rails.root + 'db/seeds/seeds_account'
require Rails.root + 'db/seeds/seeds_person_withdrawal'


###############################################################################
# アクセス管理データ
###############################################################################
#　システムデータ再生成
Seeds::SeedsSystem.delete_all
Seeds::SeedsSystem.create
#　機能データ再生成
Seeds::SeedsFunction.delete_all
Seeds::SeedsFunction.create
#　リクエスト解析スケジュールデータ再生成
Seeds::SeedsRequestAnalysisSchedule.delete_all
Seeds::SeedsRequestAnalysisSchedule.create
#　規制クッキー再生成
Seeds::SeedsRegulationCookie.delete_all
Seeds::SeedsRegulationCookie.create

###############################################################################
# 会員管理データ（マスタ）
###############################################################################
# 会員状態データ再生成
Seeds::SeedsMemberState.delete_all
Seeds::SeedsMemberState.create
# 権限データ再生成
Seeds::SeedsAuthority.delete_all
Seeds::SeedsAuthority.create
# 性別データ再生成
Seeds::SeedsGender.delete_all
Seeds::SeedsGender.create
# 国データ再生成
Seeds::SeedsCountry.delete_all
Seeds::SeedsCountry.create
# 言語データ再生成
Seeds::SeedsLanguage.delete_all
Seeds::SeedsLanguage.create
# タイムゾーンデータ再生成
Seeds::SeedsTimezone.delete_all
Seeds::SeedsTimezone.create
# 携帯キャリアデータ再生成
Seeds::SeedsMobileCarrier.delete_all
Seeds::SeedsMobileCarrier.create
# 退会理由データ再生成
Seeds::SeedsWithdrawalReason.delete_all
Seeds::SeedsWithdrawalReason.create
# 退会者状態データ再生成
Seeds::SeedsPersonWithdrawalState.delete_all
Seeds::SeedsPersonWithdrawalState.create

###############################################################################
# 会員管理ダミーデータ（テンポラリ）
###############################################################################
# アカウントデータ再生成
Seeds::SeedsAccount.delete_all
Seeds::SeedsAccount.create
# 退会者データ再生成
Seeds::SeedsPersonWithdrawal.delete_all
Seeds::SeedsPersonWithdrawal.create
