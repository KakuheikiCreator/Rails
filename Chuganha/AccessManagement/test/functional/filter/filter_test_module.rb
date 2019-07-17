# -*- coding: utf-8 -*-
###############################################################################
# ファンクショナルテスト
# テスト対象：各種フィルター
# Copyright:: Copyright (c) 2011 仲観派
# 作成日:2012/06/19 Nakanohito
# 更新日:
###############################################################################

module Filter
  module FilterTestModule
    # アクセス規制フィルターテスト
    def regulation_filter_chk(action, method, msg)
      # 規制クッキーチェック
      print_log(msg + ':01')
      begin
        @request.headers['HTTP_COOKIE'] = '123'
#        @request = TestReques.new({'HTTP_COOKIE'=>'1'})
#        @request.env['HTTP_COOKIE'] = '123'
#        cookies['123'] = '' 
#        params = {'HTTP_COOKIE'=>'123'}
#        exec_action(action, method, params)
        exec_action(action, method)
#        assert_response(:forbidden, 'AccessRegulationFilterTest(cookie):' + msg)
      rescue StandardError => ex
        print_log("Exception:" + ex.class.name)
        print_log("Message  :" + ex.message)
        print_log("Backtrace:" + ex.backtrace.join("\n"))
        flunk("AccessRegulationFilterTest(cookie):" + msg)
      end
      # 規制ホストチェック
      print_log(msg + ':02')
      begin
#        @request.headers['REMOTE_HOST'] = 'reg.client.ne.jp'
#        @request.headers['REMOTE_ADDR'] = '255.255.255.1'
#        @request.headers['HTTP_SP_HOST'] = proxy[0]
#        @request.headers['HTTP_CLIENT_IP'] = proxy[1]
#        @request.headers['HTTP_REFERER'] = referrer
#        @request.headers['HTTP_COOKIE'] = cookie
#        @request.host = 'reg.client.ne.jp'
#        @request.remote_addr = '255.255.255.1'
        params = {'REMOTE_HOST'=>'reg.client.ne.jp', 'REMOTE_ADDR'=>'255.255.255.1'}
        exec_action(action, method, params)
        exec_action(action, method)
#        assert_response(:forbidden, 'AccessRegulationFilterTest(host):'+ msg)
      rescue StandardError => ex
        print_log("Exception:" + ex.class.name)
        print_log("Message  :" + ex.message)
        print_log("Backtrace:" + ex.backtrace.join("\n"))
        flunk('AccessRegulationFilterTest(host):' + msg)
      end
      # 規制リファラーチェック
      print_log(msg + ':03')
      begin
        params = {'HTTP_REFERER'=>'www.yahoo.co.jp'}
        exec_action(action, method, params)
 #       assert_response(:forbidden, 'AccessRegulationFilterTest(referrer):'+ msg)
      rescue StandardError => ex
        print_log("Exception:" + ex.class.name)
        print_log("Message  :" + ex.message)
        print_log("Backtrace:" + ex.backtrace.join("\n"))
        flunk('AccessRegulationFilterTest(referrer):' + msg)
      end
      # 規制リクエスト頻度チェック
      print_log(msg + ':04')
      begin
        exec_action(action, method)
        exec_action(action, method)
  #      assert_response(:forbidden, 'AccessRegulationFilterTest(frequency):'+ msg)
      rescue StandardError => ex
        print_log("Exception:" + ex.class.name)
        print_log("Message  :" + ex.message)
        print_log("Backtrace:" + ex.backtrace.join("\n"))
        flunk('AccessRegulationFilterTest(frequency):' + msg)
      end
    end
    
    # メソッド規制フィルターテスト
    def method_regulation_filter_chk(action, method, msg)
      # メソッド規制チェック
      print_log(msg + ':01')
      begin
        exec_action(action, method, params)
        assert_response(:redirect, 'MethodRegulationFilterTest:' + msg)
        # リダイレクト先確認
        assert_redirected_to('/403.html', 'MethodRegulationFilterTest:' + msg)
      rescue StandardError => ex
        print_log("Exception:" + ex.class.name)
        print_log("Message  :" + ex.message)
        print_log("Backtrace:" + ex.backtrace.join("\n"))
        flunk("MethodRegulationFilterTest:" + msg)
      end
    end
  end
end