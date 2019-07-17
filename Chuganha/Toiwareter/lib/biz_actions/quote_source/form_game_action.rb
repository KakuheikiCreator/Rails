# -*- coding: utf-8 -*-
###############################################################################
# 業務アクションクラス
# 概要：引用投稿フォーム（ゲーム）アクションクラス
# コントローラー：Quote::
# アクション：
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/02/25 Nakanohito
# 更新日:
###############################################################################
require 'biz_actions/quote_source/source_base_action'
require 'data_cache/game_console_cache'

module BizActions
  module QuoteSource
    class FormGameAction < BizActions::QuoteSource::SourceBaseAction
      include DataCache
      # リーダー
      attr_reader :title, :game_console_id, :game_console_dtl_name, :sold_by, :release_date
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(controller)
        super(controller)
        # フォーム名
        @form_name = 'game'
        #######################################################################
        # 出所情報
        #######################################################################
        # 作品名
        @title = @params[:title]
        # ゲーム機ID
        @game_console_id = @params[:game_console_id]
        # ゲーム機詳細名
        @game_console_dtl_name = @params[:game_console_dtl_name]
        # 販売元
        @sold_by = @params[:sold_by]
        # 発売日
        @release_date = date_param(:release_date)
      end
      
      #########################################################################
      # public定義
      #########################################################################
      public
      # エンティティ値設定
      def set_ent_values(source_ent)
        @title = source_ent.title
        @game_console_id       = source_ent.game_console_id
        @game_console_dtl_name = source_ent.game_console_dtl_name
        @sold_by      = source_ent.sold_by
        @release_date = source_ent.release_date
      end
      
      # エンティティ生成
      def edit_ent(source_ent=nil)
        source_ent ||= SourceGame.new
        source_ent.title = @title
        source_ent.game_console_id       = @game_console_id
        source_ent.game_console_dtl_name = @game_console_dtl_name
        source_ent.sold_by      = @sold_by
        source_ent.release_date = @release_date
        return source_ent
      end
      
      #########################################################################
      # protected定義
      #########################################################################
      protected
      # 単項目チェック
      def single_item_chk?
        check_result = true
        # 作品名
        if blank?(@title) then
          @error_msg_hash[:title] = error_msg('title', :blank)
          check_result = false
        elsif overflow?(@title, 60) then
          @error_msg_hash[:title] = error_msg('title', :too_long, {:count=>60})
          check_result = false
        end
        # ゲーム機ID
        if blank?(@game_console_id) then
          @error_msg_hash[:game_console] = error_msg('game_console', :blank)
          check_result = false
        elsif !numeric?(@game_console_id) then
          @error_msg_hash[:game_console] = error_msg('game_console', :invalid)
          check_result = false
        end
        # ゲーム機詳細名
        if overflow?(@game_console_dtl_name, 60) then
          @error_msg_hash[:game_console] = error_msg('game_console', :too_long, {:count=>60})
          check_result = false
        end
        # 販売元
        if blank?(@sold_by) then
          @error_msg_hash[:sold_by] = error_msg('sold_by', :blank)
          check_result = false
        elsif overflow?(@sold_by, 60) then
          @error_msg_hash[:sold_by] = error_msg('sold_by', :too_long, {:count=>60})
          check_result = false
        end
        return check_result
      end
      
      # 項目関連チェック
      def related_items_chk?
        check_result = true
        # ゲーム機IDとゲーム機詳細名の関連チェック
        if GameConsole::ID_OTHER.to_s == @game_console_id && blank?(@game_console_dtl_name) then
          @error_msg_hash[:game_console] = error_msg('game_console', :invalid)
          check_result = false
        end
        return check_result
      end
      
      # DB関連チェック
      def db_related_chk?
        check_result = true
        # ゲーム機IDの存在チェック
        unless GameConsoleCache.instance.exist?(@game_console_id.to_i) then
          @error_msg_hash[:game_console] = error_msg('game_console', :not_found)
          check_result = false
        end
        return check_result
      end
    end
  end
end