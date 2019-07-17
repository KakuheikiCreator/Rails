# -*- coding: utf-8 -*-
###############################################################################
# クライアントIDセッタークラス
# 機能：リクエスト解析結果にクライアントIDを設定する
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2011/10/07 Nakanohito
# 更新日:
###############################################################################
require 'digest/sha1'
require 'filter/request_analysis/abstract_info_setter'

module Filter
  module RequestAnalysis
    # クライアントIDセッター
    class ClientIDSetter < AbstractInfoSetter
      #########################################################################
      # メソッド定義
      #########################################################################
      # コンストラクタ
      def initialize(setting_info, next_setter)
        super(setting_info, next_setter)
      end
      #########################################################################
      # protectedメソッド定義
      #########################################################################
      protected
      # 設定処理
      def set_values(params)
        # クライアントIDの採番済判定
        params.session[:client_id] = generate_id(params) if params.session[:client_id].nil?
      end
      # クライアントID生成
      def generate_id(params)
        remote_host = params.request.headers['REMOTE_HOST']
        now = Time.now
        return Digest::SHA1.hexdigest(remote_host.to_s + now.to_s + now.usec.to_s)
      end
    end
  end
end