# -*- coding: utf-8 -*-
###############################################################################
# シードファイル
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2012/11/14 Nakanohito
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
# Toiwareter
require Rails.root + 'db/seeds/seeds_authority'
require Rails.root + 'db/seeds/seeds_member_state'
require Rails.root + 'db/seeds/seeds_job_title'
require Rails.root + 'db/seeds/seeds_source'
require Rails.root + 'db/seeds/seeds_bbs'
require Rails.root + 'db/seeds/seeds_game_console'
require Rails.root + 'db/seeds/seeds_newspaper'
require Rails.root + 'db/seeds/seeds_sns'
require Rails.root + 'db/seeds/seeds_report_reason'
require Rails.root + 'db/seeds/seeds_delete_reason'
require Rails.root + 'db/seeds/seeds_member'
require Rails.root + 'db/seeds/seeds_quote'

###############################################################################
# アクセス管理データ
###############################################################################
#　システムデータ再生成
#Seeds::SeedsSystem.delete_all
#Seeds::SeedsSystem.create
#　機能データ再生成
#Seeds::SeedsFunction.delete_all
#Seeds::SeedsFunction.create
#　リクエスト解析スケジュールデータ再生成
#Seeds::SeedsRequestAnalysisSchedule.delete_all
#Seeds::SeedsRequestAnalysisSchedule.create
#　規制クッキー再生成
#Seeds::SeedsRegulationCookie.delete_all
#Seeds::SeedsRegulationCookie.create

###############################################################################
# Toiwareterデータ（マスタ）
###############################################################################
#　会員状態データ再生成
Seeds::SeedsMemberState.delete_all
Seeds::SeedsMemberState.create
#　権限データ再生成
Seeds::SeedsAuthority.delete_all
Seeds::SeedsAuthority.create
#　肩書きデータ再生成
Seeds::SeedsJobTitle.delete_all
Seeds::SeedsJobTitle.create
#　出所データ再生成
Seeds::SeedsSource.delete_all
Seeds::SeedsSource.create
#　電子掲示板データ再生成
Seeds::SeedsBbs.delete_all
Seeds::SeedsBbs.create
#　ゲーム機データ再生成
Seeds::SeedsGameConsole.delete_all
Seeds::SeedsGameConsole.create
#　新聞データ再生成
Seeds::SeedsNewspaper.delete_all
Seeds::SeedsNewspaper.create
#　SNSデータ再生成
Seeds::SeedsSns.delete_all
Seeds::SeedsSns.create
#　通報理由データ再生成
Seeds::SeedsReportReason.delete_all
Seeds::SeedsReportReason.create
#　削除理由データ再生成
Seeds::SeedsDeleteReason.delete_all
Seeds::SeedsDeleteReason.create
#　会員データ再生成
Seeds::SeedsMember.delete_all
Seeds::SeedsMember.create
#　引用データ再生成
Seeds::SeedsQuote.delete_all
Seeds::SeedsQuote.create
