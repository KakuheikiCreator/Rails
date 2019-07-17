# -*- coding: utf-8 -*-
###############################################################################
# ユーザー規制フィルタクラス
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/12/15 Nakanohito
# 更新日:
# 実行の前提：なし
###############################################################################
require 'data_cache/account_cache'

module Filter
  module UserRegulation
    class UserRegulationFilter
      # 定数（メッセージ関係）
      MESSAGE_HEAD   = 'User Regulation Error!!! '
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(param_hash=nil)
        @authority_hash = param_hash
        @authority_hash ||= Hash.new
      end
      
      #########################################################################
      # publicメソッド定義
      #########################################################################
      public
      # フィルタ処理
      def filter(controller)
        controller.logger.debug('UserRegulationFilter Execute!!!')
        # ユーザーの存在チェック
        user_id = controller.session[:user_id]
        unless DataCache::AccountCache.instance.valid_user?(user_id) then
          controller.logger.warn(MESSAGE_HEAD + 'UserID is invalid!:' + user_id.to_s)
          render_error(controller)
        end
        # 管理者権限判定
        return if @authority_hash[controller.params[:action].to_sym] != true
        if controller.session[:authority_cls] != Authority::AUTHORITY_CLS_ADMIN then
          controller.logger.warn(MESSAGE_HEAD + 'authority invalid! UserID:' + user_id.to_s)
          render_error(controller)
        end
      end
      
      #########################################################################
      # protectedメソッド定義
      #########################################################################
      protected
      # エラーレスポンス
      def render_error(controller)
        controller.render(:file=>"#{Rails.root}/public/403.html", :status=>403, :layout=>false)
      end
    end
  end
end