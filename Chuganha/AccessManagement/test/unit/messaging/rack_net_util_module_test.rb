# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：Rack用ネットユーティリティモジュール
# Copyright:: Copyright (c) 2011 仲務省
# 作成日:2012/04/26 Nakanohito
# 更新日:
###############################################################################
require 'test_helper'
require 'unit/unit_test_util'
require 'unit/mock/mock_request'
require 'messaging/rack_net_util_module'

class RackNetUtilModuleTest < ActiveSupport::TestCase
  include Mock
  include UnitTestUtil
  include Messaging::RackNetUtilModule

  # テスト対象メソッド：ambiguous_ex_ip
  test "CASE:2-12 ambiguous_ex_ip" do
    # 正常ケース（10進表現）
    str = '00101.255.0.10000'
    assert(ambiguous_ex_ip(str) == '101.255.0.100', "CASE:2-12-1")
    str = '0001.255.0.256'
    assert(ambiguous_ex_ip(str) == '1.255.0.25', "CASE:2-12-1")
    # 正常ケース（16進表現）
    str = '00ff.ff.0.010000'
    assert(ambiguous_ex_ip(str) == '255.255.0.1', "CASE:2-12-2")
    str = '0001.ff.0.fg'
    assert(ambiguous_ex_ip(str) == '1.255.0.15', "CASE:2-12-2")
    # 正常ケース（IP含まず）
    str = 'IP以外の値'
    assert(ambiguous_ex_ip(str).nil?, "CASE:2-12-3")
    # 異常ケース
    assert(ambiguous_ex_ip(nil).nil?, "CASE:2-12-4")
    assert(ambiguous_ex_ip(1).nil?, "CASE:2-12-4")
  end

  # テスト対象メソッド：extract_host
  test "CASE:2-15 extract_host" do
    # 正常ケース
    # プロキシ未使用ケース
    request = MockRequest.new
    request.headers['REMOTE_HOST'] = 'test.host.name.com'
    request.headers['REMOTE_ADDR'] = '255.255.0.1'
    info = extract_host(request)
    assert(info.size == 2, "CASE:2-15-1")
    assert(info[0] == 'test.host.name.com', "CASE:2-15-2")
    assert(info[1] == '255.255.0.1', "CASE:2-15-3")
    # プロキシ使用ケース
    request.headers['REMOTE_HOST'] = 'test.proxy.name.com'
    request.headers['REMOTE_ADDR'] = '255.255.0.1'
    request.headers['HTTP_SP_HOST'] = 'test.client.name.com'
    request.headers['HTTP_CLIENT_IP'] = '255.254.0.1'
    info = extract_host(request)
    assert(info.size == 4, "CASE:2-15-4")
    assert(info[0] == 'test.client.name.com', "CASE:2-15-5")
    assert(info[1] == '255.254.0.1', "CASE:2-15-6")
    assert(info[2] == 'test.proxy.name.com', "CASE:2-15-7")
    assert(info[3] == '255.255.0.1', "CASE:2-15-8")
    # 異常ケース
    assert(extract_host(nil).nil?, "CASE:2-15-9")
    assert(extract_host(1).nil?, "CASE:2-15-9")
  end

  # テスト対象メソッド：extract_ip
  test "CASE:2-6 extract_ip" do
    # 正常ケース
    str = '00101.255.0.10000'
    assert(extract_ip(str) == '101.255.0.100', "CASE:2-6-1")
    str = '0001.255.0.256'
    assert(extract_ip(str) == '1.255.0.25', "CASE:2-6-1")
    str = '0256.0.255.001'
    assert(extract_ip(str) == '56.0.255.0', "CASE:2-6-1")
    # 異常ケース
    assert(extract_ip(nil).nil?, "CASE:2-6-2")
    str = '025a.0.255.001.100'
    assert(extract_ip(str).nil?, "CASE:2-6-3")
    str = 'abcd300.255.30.bfr'
    assert(extract_ip(str).nil?, "CASE:2-6-3")
    str = '0258.0.256.1.100'
    assert(extract_ip(str).nil?, "CASE:2-6-4")
    str = '025.300.255.300.100'
    assert(extract_ip(str).nil?, "CASE:2-6-4")
  end

  # テスト対象メソッド：extract_ip_0x
  test "CASE:2-7 extract_ip_0x" do
    # 正常ケース
    str = '00ff.ff.0.010000'
    assert(extract_ip_0x(str) == '255.255.0.1', "CASE:2-7-1")
    str = '0001.ff.0.fg'
    assert(extract_ip_0x(str) == '1.255.0.15', "CASE:2-7-1")
    str = '0gf.0.ff.001'
    assert(extract_ip_0x(str) == '15.0.255.0', "CASE:2-7-1")
    str = 'fgab00abffgh'
    assert(extract_ip_0x(str) == '171.0.171.255', "CASE:2-7-2")
    str = 'fg0b00ab0fghi'
#    print("IP:", extract_ip_0x(str), "\n")
    assert(extract_ip_0x(str) == '11.0.171.15', "CASE:2-7-2")
    # 正常ケース（IP無し）
    assert(extract_ip_0x(nil).nil?, "CASE:2-7-3")
    str = 'fg0b00gb0fghi'
    assert(extract_ip_0x(str).nil?, "CASE:2-7-4")
    str = 'fg0g00ab0fghi'
    assert(extract_ip_0x(str).nil?, "CASE:2-7-4")
  end

  # テスト対象メソッド：ex_remote_host
  test "CASE:2-14 ex_remote_host" do
    # 正常ケース
    request = MockRequest.new
    request.headers['REMOTE_HOST'] = 'test.host.name.com'
    request.headers['REMOTE_ADDR'] = '255.255.0.1'
    info = ex_remote_host(request)
    assert(info[0] == 'test.host.name.com', "CASE:2-14-1")
    assert(info[1] == '255.255.0.1', "CASE:2-14-2")
    # 異常ケース
    assert(ex_proxy_client(nil).nil?, "CASE:2-14-3")
    assert(ex_proxy_client(1).nil?, "CASE:2-14-3")
  end

  # テスト対象メソッド：ex_proxy_client
  test "CASE:2-13 ex_proxy_client" do
    # 正常ケース
    request = MockRequest.new
    request.headers['HTTP_SP_HOST'] = 'test.host.name.com'
    request.headers['HTTP_CLIENT_IP'] = '255.255.0.1'
    info = ex_proxy_client(request)
    assert(info[0] == 'test.host.name.com', "CASE:2-13-1")
    assert(info[1] == '255.255.0.1', "CASE:2-13-2")
    #
    request.headers.clear
    request.headers['HTTP_SP_HOST'] = 'test.host.name.com'
    request.headers['HTTP_CLIENT_IP'] = '00ff.ff.0.010000'
    info = ex_proxy_client(request)
    assert(info[0] == 'test.host.name.com', "CASE:2-13-1")
    assert(info[1] == '255.255.0.1', "CASE:2-13-2")
    # 
    request.headers.clear
    request.headers['HTTP_SP_HOST'] = 'test.host.name.com'
    request.headers['HTTP_CLIENTIP'] = '255.255.0.1'
    info = ex_proxy_client(request)
    assert(info[0] == 'test.host.name.com', "CASE:2-13-1")
    assert(info[1] == '255.255.0.1', "CASE:2-13-3")
    #
    request.headers.clear
    request.headers['HTTP_SP_HOST'] = 'test.host.name.com'
    request.headers['HTTP_CLIENTIP'] = '00ff.ff.0.010000'
    info = ex_proxy_client(request)
    assert(info[0] == 'test.host.name.com', "CASE:2-13-1")
    assert(info[1] == '255.255.0.1', "CASE:2-13-3")
    #
    request.headers.clear
    request.headers['HTTP_SP_HOST'] = 'test.host.name.com'
    request.headers['HTTP_FORWARDED'] = '255.255.0.1'
    info = ex_proxy_client(request)
    assert(info[0] == 'test.host.name.com', "CASE:2-13-1")
    assert(info[1] == '255.255.0.1', "CASE:2-13-4")
    #
    request.headers.clear
    request.headers['HTTP_SP_HOST'] = 'test.host.name.com'
    request.headers['HTTP_FORWARDED'] = '00ff.ff.0.010000'
    info = ex_proxy_client(request)
    assert(info[0] == 'test.host.name.com', "CASE:2-13-1")
    assert(info[1] == '255.255.0.1', "CASE:2-13-4")
    #
    request.headers.clear
    request.headers['HTTP_SP_HOST'] = 'test.host.name.com'
    request.headers['HTTP_FROM'] = '255.255.0.1'
    info = ex_proxy_client(request)
    assert(info[0] == 'test.host.name.com', "CASE:2-13-1")
    assert(info[1] == '255.255.0.1', "CASE:2-13-5")
    #
    request.headers.clear
    request.headers['HTTP_SP_HOST'] = 'test.host.name.com'
    request.headers['HTTP_FROM'] = '00ff.ff.0.010000'
    info = ex_proxy_client(request)
    assert(info[0] == 'test.host.name.com', "CASE:2-13-1")
    assert(info[1] == '255.255.0.1', "CASE:2-13-5")
    #
    request.headers.clear
    request.headers['HTTP_SP_HOST'] = 'test.host.name.com'
    request.headers['HTTP_VIA'] = '255.255.0.1'
    info = ex_proxy_client(request)
    assert(info[0] == 'test.host.name.com', "CASE:2-13-1")
    assert(info[1] == '255.255.0.1', "CASE:2-13-6")
    #
    request.headers.clear
    request.headers['HTTP_SP_HOST'] = 'test.host.name.com'
    request.headers['HTTP_VIA'] = '00ff.ff.0.010000'
    info = ex_proxy_client(request)
    assert(info[0] == 'test.host.name.com', "CASE:2-13-1")
    assert(info[1] == '255.255.0.1', "CASE:2-13-6")
    #
    request.headers.clear
    request.headers['HTTP_SP_HOST'] = 'test.host.name.com'
    request.headers['HTTP_X_FORWARDED_FOR'] = '255.255.0.1'
    info = ex_proxy_client(request)
    assert(info[0] == 'test.host.name.com', "CASE:2-13-1")
    assert(info[1] == '255.255.0.1', "CASE:2-13-7")
    #
    request.headers.clear
    request.headers['HTTP_SP_HOST'] = 'test.host.name.com'
    request.headers['HTTP_X_FORWARDED_FOR'] = '00ff.ff.0.010000'
    info = ex_proxy_client(request)
    assert(info[0] == 'test.host.name.com', "CASE:2-13-1")
    assert(info[1] == '255.255.0.1', "CASE:2-13-7")
    #
    request.headers.clear
    request.headers['HTTP_SP_HOST'] = 'test.host.name.com'
    request.headers['HTTP_X_LOCKING'] = '255.255.0.1'
    info = ex_proxy_client(request)
    assert(info[0] == 'test.host.name.com', "CASE:2-13-1")
    assert(info[1] == '255.255.0.1', "CASE:2-13-8")
    #
    request.headers.clear
    request.headers['HTTP_SP_HOST'] = 'test.host.name.com'
    request.headers['HTTP_X_LOCKING'] = '00ff.ff.0.010000'
    info = ex_proxy_client(request)
    assert(info[0] == 'test.host.name.com', "CASE:2-13-1")
    assert(info[1] == '255.255.0.1', "CASE:2-13-8")
    #
    request.headers.clear
    request.headers['HTTP_SP_HOST'] = nil
    request.headers['HTTP_X_LOCKING'] = '125.1.88.31'
    info = ex_proxy_client(request)
    assert(info[0] == 'nfmv002031.uqw.ppp.infoweb.ne.jp', "CASE:2-13-9")
    assert(info[1] == '125.1.88.31', "CASE:2-13-8")
    #
    request.headers.clear
    request.headers['HTTP_SP_HOST'] = 'nfmv002031.uqw.ppp.infoweb.ne.jp'
    request.headers['HTTP_X_LOCKING'] = nil
    info = ex_proxy_client(request)
    assert(info[0] == 'nfmv002031.uqw.ppp.infoweb.ne.jp', "CASE:2-13-1")
    assert(info[1] == '125.1.88.31', "CASE:2-13-10")
    #
    request.headers.clear
    info = ex_proxy_client(request)
    assert(info[0].nil?, "CASE:2-13-11")
    assert(info[1].nil?, "CASE:2-13-11")
    # 異常ケース
    assert(ex_proxy_client(nil).nil?, "CASE:2-13-12")
    assert(ex_proxy_client(1).nil?, "CASE:2-13-12")
  end

  # テスト対象メソッド：inquiry_hostname
  test "CASE:2-8 inquiry_hostname" do
    # 正常ケース
#    print("HOST NAME:", inquiry_hostname('219.104.169.235'), "\n")
    hostname = inquiry_hostname('124.24.244.123')
#    print("HOST NAME:", hostname, "\n")
    assert(hostname == 'nfmv001067123.uqw.ppp.infoweb.ne.jp', "CASE:2-8-1")
    hostname = inquiry_hostname('255.0.0.100')
#    print("HOST NAME:", hostname, "\n")
    assert(hostname.nil?, "CASE:2-8-2")
    assert(inquiry_hostname(nil).nil?, "CASE:2-8-3")
    hostname = inquiry_hostname('abcdefg')
#    print("HOST NAME:", hostname, "\n")
    assert(hostname.nil?, "CASE:2-8-4")
    assert(inquiry_hostname(10).nil?, "CASE:2-8-5")
  end

  # テスト対象メソッド：inquiry_address
  test "CASE:2-9 inquiry_address" do
    # 正常ケース
    ip = inquiry_address('f11.top.vip.ogk.yahoo.co.jp')
    assert(ip == '124.83.187.140', "CASE:2-9-1")
    ip = inquiry_address('msn.com')
    assert(ip == '65.55.206.203', "CASE:2-9-1")
    ip = inquiry_address('abcdefg')
    assert(ip.nil?, "CASE:2-9-3")
    assert(inquiry_address(nil).nil?, "CASE:2-9-2")
    ip = inquiry_address(1)
#    print("HOST NAME:", hostname, "\n")
    assert(ip.nil?, "CASE:2-9-4")
  end

  # テスト対象メソッド：use_proxy?
  test "CASE:2-11 use_proxy?" do
    # 正常ケース
    request = MockRequest.new
    request.headers['HTTP_PROXY_CONNECTION'] = 'Keep-Alive'
    assert(use_proxy?(request), "CASE:2-11-1")
    request.headers.clear
    request.headers['HTTP_CACHE_CONTROL'] = 'max-stale=xxxx'
    assert(use_proxy?(request), "CASE:2-11-2")
    request.headers.clear
    request.headers['HTTP_IF_MODIFIED_SINCE'] = '2012:01:04 09:51:00'
    assert(use_proxy?(request), "CASE:2-11-3")
    request.headers.clear
    request.headers['HTTP_SP_HOST'] = 'nfmv001012086.uqw.ppp.infoweb.ne.jp'
    assert(use_proxy?(request), "CASE:2-11-4")
    request.headers.clear
    request.headers['HTTP_CLIENT_IP'] = '175.179.198.86'
    assert(use_proxy?(request), "CASE:2-11-5")
    request.headers.clear
    request.headers['HTTP_CLIENTIP'] = '175.179.198.86'
    assert(use_proxy?(request), "CASE:2-11-6")
    request.headers.clear
    request.headers['HTTP_FORWARDED'] = '175.179.198.86'
    assert(use_proxy?(request), "CASE:2-11-7")
    request.headers.clear
    request.headers['HTTP_FROM'] = 'AFB3C656'
    assert(use_proxy?(request), "CASE:2-11-8")
    request.headers.clear
    request.headers['HTTP_VIA'] = 'AFB3C656'
    assert(use_proxy?(request), "CASE:2-11-9")
    request.headers.clear
    request.headers['HTTP_X_FORWARDED_FOR'] = '175.179.198.86'
    assert(use_proxy?(request), "CASE:2-11-10")
    request.headers.clear
    request.headers['HTTP_X_LOCKING'] = '175.179.198.86'
    assert(use_proxy?(request), "CASE:2-11-11")
    request.headers.clear
    assert(!use_proxy?(request), "CASE:2-11-12")
    # 異常ケース
    assert(!use_proxy?(nil), "CASE:2-11-13")
    assert(!use_proxy?(1), "CASE:2-11-13")
  end
end
