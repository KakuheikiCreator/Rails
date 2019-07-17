# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：引用投稿フォーム（音楽）アクションクラス
# コントローラー：Quote::
# アクション：
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/02/25 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/quote_source/source_base_action'
require 'biz_common/biz_validation_module'

module BizActions
  module QuoteSource
    class FormMusicAction < BizActions::QuoteSource::SourceBaseAction
      include BizCommon::BizValidationModule
      # リーダー
      attr_reader :music_name, :lyricist, :composer, :jasrac_code, :iswc
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        # フォーム名
        @form_name = 'music'
        #######################################################################
        # 出所情報
        #######################################################################
        # 音楽名
        @music_name = @params[:music_name]
        # 作詞家
        @lyricist = @params[:lyricist]
        # 作曲家
        @composer = @params[:composer]
        # JASRACコード
        @jasrac_code = @params[:jasrac_code]
        # ISWC
        @iswc = @params[:iswc]
      end
      
      #########################################################################
      # public定義
      #########################################################################
      public
      # エンティティ値設定
      def set_ent_values(source_ent)
        @music_name  = source_ent.music_name
        @lyricist    = source_ent.lyricist
        @composer    = source_ent.composer
        @jasrac_code = source_ent.jasrac_code
        @iswc        = source_ent.iswc
      end
      
      # エンティティ生成
      def edit_ent(source_ent=nil)
        source_ent ||= SourceMusic.new
        source_ent.music_name  = @music_name
        source_ent.lyricist    = @lyricist
        source_ent.composer    = @composer
        source_ent.jasrac_code = @jasrac_code
        source_ent.iswc        = @iswc
        return source_ent
      end
      
      #########################################################################
      # protected定義
      #########################################################################
      protected
      # 単項目チェック
      def single_item_chk?
        check_result = true
        # 音楽名
        if blank?(@music_name) then
          @error_msg_hash[:music_name] = error_msg('music_name', :blank)
          check_result = false
        elsif overflow?(@music_name, 60) then
          @error_msg_hash[:music_name] = error_msg('music_name', :too_long, {:count=>60})
          check_result = false
        end
        # 作詞家
        if overflow?(@lyricist, 60) then
          @error_msg_hash[:lyricist] = error_msg('lyricist', :too_long, {:count=>60})
          check_result = false
        end
        # 作曲家
        if blank?(@composer) then
          @error_msg_hash[:composer] = error_msg('composer', :blank)
          check_result = false
        elsif overflow?(@composer, 60) then
          @error_msg_hash[:composer] = error_msg('composer', :too_long, {:count=>60})
          check_result = false
        end
        # JASRACコード
        if !blank?(@jasrac_code) && !jasrac_cd?(@jasrac_code) then
          @error_msg_hash[:jasrac_code] = error_msg('jasrac_code', :invalid)
          check_result = false
        end
        # ISWC
        if !blank?(@iswc) && !iswc?(@iswc) then
          @error_msg_hash[:iswc] = error_msg('iswc', :invalid)
          check_result = false
        end
        return check_result
      end
    end
  end
end