# -*- coding: utf-8 -*-
###############################################################################
# 業務初期処理
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2011/10/26 Nakanohito
# 更新日:
###############################################################################
# 業務設定
require 'biz_common/business_config'
# ロードクラス
require "function_state/function_state_hash"
require "function_state/function_state"
require "function_state/hash_state"

###############################################################################
# 設定情報ロード
###############################################################################
BizCommon::BusinessConfig.instance

###############################################################################
# クラスロード
###############################################################################
FunctionState::FunctionState
FunctionState::FunctionStateHash
FunctionState::HashState

###############################################################################
# ビジネスロジック初期処理
###############################################################################
# 暗号化設定情報の読み込み
#EncryptionSetting.instance
