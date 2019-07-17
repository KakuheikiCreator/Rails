# -*- coding: utf-8 -*-
###############################################################################
# ユーザー規制フィルタクラス
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2013/01/09 Nakanohito
# 更新日:
# 実行の前提：なし
###############################################################################

module Filter
  module MemberRegulation
    class MemberRegulationFilter
      # 定数（メッセージ関係）
      MESSAGE_HEAD   = 'Member Regulation Error!!! '
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(param_hash={})
        @authority_hash = param_hash
      end
      
      #########################################################################
      # publicメソッド定義
      #########################################################################
      public
      # フィルタ処理
      def filter(controller)
        controller.logger.debug('MemberRegulationFilter Execute!!!')
        # ユーザーの存在チェック
        member_id = controller.session[:member_id]
        if member_id.nil? then
          controller.logger.warn(MESSAGE_HEAD + 'MemberID is invalid!')
          controller.render_403
          return
        end
        # 管理者権限判定
        if @authority_hash[:all] != true then
          return if @authority_hash[controller.params[:action].to_sym] != true
        end
        if controller.session[:authority_cls] != Authority::AUTHORITY_CLS_ADMIN then
          controller.logger.warn(MESSAGE_HEAD + 'authority invalid! MemberID:' + member_id.to_s)
          controller.render_403
          return
        end
      end
    end
  end
end