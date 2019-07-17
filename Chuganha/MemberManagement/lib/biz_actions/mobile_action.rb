# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：携帯アクセスの基底アクション
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/12/16 Nakanohito
# 更新日:
###############################################################################

module BizActions
  class MobileAction < BizActions::BusinessAction
    include DataCache
    ###########################################################################
    # コンストラクタ
    ###########################################################################
    def initialize(controller)
      super(controller)
      # パラメータ
      @mobile_carrier_cd = nil
      @mobile_id_blank_flg = nil
      @mobile_host = get_mobile_host
      @mobile_id_no = get_mobile_id_no
      @logger.debug('MobileAction mobile_carrier_cd:' + @mobile_carrier_cd.to_s)
      @logger.debug('MobileAction mobile_id_blank_flg:' + @mobile_id_blank_flg.to_s)
      @logger.debug('MobileAction mobile_host:' + @mobile_host.to_s)
      @logger.debug('MobileAction mobile_id_no:' + @mobile_id_no.to_s)
    end
    
    ###########################################################################
    # protected定義
    ###########################################################################
    protected
    # リモートホスト情報取得
    def get_mobile_host
      # リモートホスト情報取得
      remote_host = @request.headers['REMOTE_HOST']
      # キャリア判別
      @mobile_id_blank_flg = false
      if !(/^proxy\d{6}\.docomo\.ne\.jp$/ =~ remote_host).nil? then
        # Docomo iMode
        @mobile_carrier_cd = MobileCarrier::CARRIER_CD_DOCOMO
      elsif !(/^s\d{6}\..*\.spmode\.ne\.jp$/ =~ remote_host).nil? then
        # Docomo SPモード（スマートフォン）
        @mobile_carrier_cd = MobileCarrier::CARRIER_CD_DOCOMO
        @mobile_id_blank_flg = true
      elsif !(/^wb\d{2}proxy\d{4}\.ezweb\.ne\.jp$/ =~ remote_host).nil? then
        # AU ezweb
        @mobile_carrier_cd = MobileCarrier::CARRIER_CD_AU
      elsif !(/^[A-Za-z]{2}\d{6}\.brew\.ne\.jp$/ =~ remote_host).nil? then
        # AU PCサイトビューワー
        @mobile_carrier_cd = MobileCarrier::CARRIER_CD_AU
      elsif !(/^KD\d{12}\.au-net\.ne\.jp$/ =~ remote_host).nil? then
        # AU ISNET（スマートフォン）, iPhone（スマートフォン）, +WiMAX
        @mobile_carrier_cd = MobileCarrier::CARRIER_CD_AU
        @mobile_id_blank_flg = true
      elsif !(/^[0-9A-Za-z]{5}\.jp-[chtcrknsq]{1}\.ne\.jp$/ =~ remote_host).nil? then
        # SoftBank Yahoo!ケータイ
        @mobile_carrier_cd = MobileCarrier::CARRIER_CD_SOFTBANK
      elsif !(/^[0-9A-Za-z]{5}\.pcsitebrowser\.ne\.jp$/ =~ remote_host).nil? then
        # SoftBank PCサイトブラウザ
        @mobile_carrier_cd = MobileCarrier::CARRIER_CD_SOFTBANK
      elsif !(/^[0-9A-Za-z]{5}\.openmobile\.ne\.jp$/ =~ remote_host).nil? then
        # SoftBank Xシリーズ, スマートフォン
        @mobile_carrier_cd = MobileCarrier::CARRIER_CD_SOFTBANK
        @mobile_id_blank_flg = true
      elsif !(/^[0-9A-Za-z]{5}\.panda-world\.ne\.jp$/ =~ remote_host).nil? then
        # SoftBank iPhone
        @mobile_carrier_cd = MobileCarrier::CARRIER_CD_SOFTBANK
        @mobile_id_blank_flg = true
      elsif !(/^P[0-9A-Za-z]{12}\.ppp\.prin\.ne\.jp$/ =~ remote_host).nil? then
        # Willcom
        @mobile_carrier_cd = MobileCarrier::CARRIER_CD_WILLCOM
        @mobile_id_blank_flg = true
      elsif !(/^[eE]{1}M\d{3}-\d{3}-\d{3}-\d{3}\.pool\.emobile\.ad\.jp$/ =~ remote_host).nil? then
        # イーモバイル　EMnet
        @mobile_carrier_cd = MobileCarrier::CARRIER_CD_EMOBILE
      elsif !(/^EM\d{3}-\d{3}-\d{3}-\d{3}\.pool\.e-mobile\.ne\.jp$/ =~ remote_host).nil? then
        # イーモバイル　EMnet非経由（データカードなど）
        @mobile_carrier_cd = MobileCarrier::CARRIER_CD_EMOBILE
      else
        # テスト用
        @mobile_carrier_cd = MobileCarrier::CARRIER_CD_AU
#        @mobile_id_blank_flg = true
      end
      return remote_host
    end
    
    # 個体識別番号取得
    def get_mobile_id_no
      mobile_id_no = nil
      # 個体識別番号の有無判定
      return mobile_id_no if @mobile_id_blank_flg
      # iモードID取得（Docomo）
      if MobileCarrier::CARRIER_CD_DOCOMO == @mobile_carrier_cd then
        mobile_id_no = @request.headers['HTTP_X_DCMGUID']
      elsif MobileCarrier::CARRIER_CD_AU == @mobile_carrier_cd then
        # サブスクライバID（au）
        mobile_id_no = @request.headers['HTTP_X_UP_SUBNO']
      elsif MobileCarrier::CARRIER_CD_SOFTBANK == @mobile_carrier_cd then
        # X_JPHONE_UID（Softbank/Disney）
        mobile_id_no = @request.headers['HTTP_X_JPHONE_UID']
      elsif MobileCarrier::CARRIER_CD_EMOBILE == @mobile_carrier_cd then
        # X_EM_UID（イーモバイル）
        mobile_id_no = @request.headers['HTTP_X_EM_UID']
      end
      return mobile_id_no
    end
  end
end