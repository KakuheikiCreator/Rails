# -*- coding: utf-8 -*-
###############################################################################
# テスト用プロセス
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/04/27 Nakanohito
# 更新日:
###############################################################################
require 'messaging/processing_xml'

module BizMessageProcess
  class BizTestProcess
    include Messaging
    public
    # テスト処理
    def execute?(message_xml)
#      Rails.logger.debug('TestProcess execute!!! msg:' + message_xml.to_s)
#      proc_id = message_xml.elements[ProcessingXML::PATH_PROCESS_ID].text
      proc_id = message_xml.process_id
      Rails.logger.debug('Process ID:' + proc_id)
#      Rails.logger.debug('Check:' + (proc_id == 'test_proc_id').to_s)
      return (proc_id == 'process_id')
    end
  end
end