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
require Rails.root + 'db/seeds/seeds_system'
require Rails.root + 'db/seeds/seeds_function'
require Rails.root + 'db/seeds/seeds_request_analysis_schedule'
require Rails.root + 'db/seeds/seeds_regulation_cookie'

#　システムデータ再生成
Seeds::SeedsSystem.delete_all
Seeds::SeedsSystem.create
#　機能データ再生成
Seeds::SeedsFunction.delete_all
Seeds::SeedsFunction.create
#　リクエスト解析スケジュールデータ再生成
#Seeds::SeedsRequestAnalysisSchedule.delete_all
#Seeds::SeedsRequestAnalysisSchedule.create
#　規制クッキー再生成
#Seeds::SeedsRegulationCookie.delete_all
#Seeds::SeedsRegulationCookie.create
