# -*- coding: utf-8 -*-
###############################################################################
# 業務ドキュメントクラス
# 概要：業務的なドキュメント情報を保持するクラス
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2012/11/18 Nakanohito
# 更新日:
###############################################################################
require 'singleton'
require 'thread'

module BizCommon
  class BizDocument
    include Singleton
    # アクセサー
    attr_reader :agreement, :privacy_policy
    ###########################################################################
    # コンストラクタ
    ###########################################################################
    def initialize
      # 排他制御オブジェクト生成
      @mutex = Mutex.new
      # ドキュメントハッシュ
      @doc_hash = Hash.new
      # 会員規約情報
      @agreement = read_file('membership_agreement.txt')
      @doc_hash[:agreement] = @agreement
      # 個人情報保護方針
      @privacy_policy = read_file('privacy_policy.txt')
      @doc_hash[:privacy_policy] = @privacy_policy
      # 外部サービスへの情報提供規約
      @terms_of_providing = read_file('terms_of_providing.txt')
      @doc_hash[:terms_of_providing] = @terms_of_providing
    end
    
    ###########################################################################
    # public定義
    ###########################################################################
    public
    # メンバーアクセス
    def [](doc_name)
      @mutex.synchronize do
        return @doc_hash[doc_name.to_sym]
      end
    end
    
    # HTMLタグを除去した値を取得
    def strip_tags(doc_name)
      @mutex.synchronize do
        doc_val = @doc_hash[doc_name.to_sym]
        return ActionView::Helpers::TextHelper.strip_tags(doc_val.to_s)
      end
    end
    
    ###########################################################################
    # protected定義
    ###########################################################################
    protected
    # ファイル読み込み
    def read_file(file_name)
      file_path = Rails.root.join('config', 'business', file_name).to_s
      file = open(file_path)
      return file.read
    end
  end
end