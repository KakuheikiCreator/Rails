# -*- coding: utf-8 -*-
###############################################################################
# メソッド規制フィルタモジュール
# Copyright:: Copyright (c) 2013 仲観派
# 作成日:2012/02/02 Nakanohito
# 更新日:
# 実行の前提：なし
###############################################################################
require 'common/message_util_module'
require 'common/net_util_module'

module Filter
  module MethodRegulation
    class MethodRegulationFilter
      include Common::MessageUtilModule
      include Common::NetUtilModule
      # 定数（メッセージ関係）
      MESSAGE_HEAD   = 'Method Regulation Error!!!::'
      #########################################################################
      # コンストラクタ
      #########################################################################
      def initialize(arg=[:GET, :POST])
        @regulation_list = Array.new
        if String === arg || Symbol === arg then
          @regulation_list.push(arg.to_s)
        elsif Array === arg then
          arg.each do |method| @regulation_list.push(method.to_s) end
        end
      end
      #########################################################################
      # publicメソッド定義
      #########################################################################
      public
      # フィルタ処理
      def filter(controller)
        controller.logger.debug('MethodRegulationFilter Execute!!!')
        return if controller.flash[:redirect_flg] == true
        # リクエストメソッド判定
        unless @regulation_list.include?(controller.request.request_method) then
          error_msg = error_msg('filter.method_regulation.attributes.request_method', 'invalid')
          log_output(controller, error_msg)
          controller.redirect_to('/403.html')
        end
      end
      
      #########################################################################
      # protected定義
      #########################################################################
      protected
      # ログメッセージ出力
      def log_output(controller, error_msg)
        method_msg = ':Method=' + controller.request.request_method.to_s
        host_info = extract_host(controller.request)
        host_msg = ('(HOST:' + host_info[0].to_s + ')') if host_info.size == 2
        host_msg ||= ('(HOST:' + host_info[0].to_s + ', PROXY:' + host_info[2].to_s + ')')
        controller.logger.warn(MESSAGE_HEAD + error_msg.to_s + method_msg + host_msg)
      end
    end
  end
end