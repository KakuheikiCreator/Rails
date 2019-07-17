# -*- coding: utf-8 -*-
###############################################################################
# ユニットテストクラス
# テスト対象：ネットチェックモジュール
# Copyright:: Copyright (c) 2011 仲務省
# 作成日:2011/08/24 Nakanohito
# 更新日:
###############################################################################
require 'test_helper'
require 'unit/unit_test_util'
require 'unit/mock/mock_request'
require 'common/net_util_module'

class NetUtilModuleTest < ActiveSupport::TestCase
  include Mock
  include UnitTestUtil
  include Common::NetUtilModule

  # テスト対象メソッド：valid_url?
  test "CASE:2-1 valid_uri?" do
    # 正常ケース
    assert(valid_uri?("http://sankei.jp.msn.com/world/news/110701/amr11070119540012-n1.htm"), "CASE:2-1-1")
    assert(valid_uri?("http://localhost:3000/sample/scr_trans/post"), "CASE:2-1-1")
    assert(valid_uri?("https://login.yahoo.co.jp/config/login?.src=www&.done=http://www.yahoo.co.jp"), "CASE:2-1-2")
    assert(valid_uri?("ftp://ftp1.freebsd.org/pub/FreeBSD/"), "CASE:2-1-3")
    assert(!valid_uri?("nakayan@taihen.com"), "CASE:2-1-4")
    assert(!valid_uri?("htt://sdlfjslid.com/sjdlfsie.png"), "CASE:2-1-5")
    assert(!valid_uri?(1), "CASE:2-1-6")
    # 異常ケース：なし
  end

  # テスト対象メソッド：valid_email?
  test "CASE:2-2 valid_email?" do
    # 正常ケース
    assert(valid_email?("nakayan@taihen.com"), "CASE:2-2-1")
    assert(valid_email?("dankogai+regexp@gmail.com"), "CASE:2-2-1")
    assert(!valid_email?("http://sankei.jp.msn.com/world/news/110701/amr11070119540012-n1.htm"), "CASE:2-2-2")
    assert(!valid_email?("https://login.yahoo.co.jp/config/login?.src=www&.done=http://www.yahoo.co.jp"), "CASE:2-2-3")
    assert(!valid_email?("ftp://ftp1.freebsd.org/pub/FreeBSD/"), "CASE:2-2-4")
    assert(!valid_email?("htttp:///sdlfjslid.com/sjdlfsie.png"), "CASE:2-2-5")
    assert(!valid_email?("da.me..@docomo.ne.jp"), "CASE:2-2-5")
    assert(!valid_email?(1), "CASE:2-2-6")
    # 異常ケース：なし
  end

  # テスト対象メソッド：valid_host_name?
  test "CASE:2-3 valid_host_name?" do
    # 正常ケース(True)
    label = generate_str(CHAR_SET_ALPHABETIC, 60)
    host_name_max1 = label + '.' + label + '.' + label + '.' + label + '.' + 'abcdefgh.jp'
    assert(valid_host_name?(host_name_max1), "CASE:2-3-1")
    host_name_max2 = label + '.' + label + '.' + label + '.' + label + '.' + 'ab-defgh.jp'
    assert(valid_host_name?(host_name_max2), "CASE:2-3-1")
    host_name_pattern_1  = '0-0.' + label + '.' + label + '.' + 'abcdefghijkl.jp'
    assert(valid_host_name?(host_name_pattern_1), "CASE:2-3-1")
    host_name_pattern_2  = label + 'c0a.' + label + '.' + 'abcdefghijkl.jp'
    assert(valid_host_name?(host_name_pattern_2), "CASE:2-3-1")
    # 正常ケース(False)
    assert(!valid_host_name?(nil), "CASE:2-3-2")
    host_name_over1 = label + '.' + label + '.' + label + '.' + label + '.' + 'abcdefghi.jp'
    assert(!valid_host_name?(host_name_over1), "CASE:2-3-3")
    host_name_over2 = label + '.' + label + '.' + label + '.' + label + 'abc-.' + 'abcde.jp'
    assert(!valid_host_name?(host_name_over2), "CASE:2-3-4")
    host_name_pattern_3  = label + '.-0ab.' + label + '.' + 'abcdefghijkl.jp'
    assert(!valid_host_name?(host_name_pattern_3), "CASE:2-3-5")
    host_name_pattern_4  = label + '.ab5-.' + label + '.' + 'abcdefghijkl.jp'
    assert(!valid_host_name?(host_name_pattern_4), "CASE:2-3-6")
    # 異常ケース：なし
  end

  # テスト対象メソッド：valid_ip_address?
  test "CASE:2-4 valid_ip_address?" do
    # 正常ケース(True)
    assert(valid_ip_address?('0.0.0.0'), "CASE:2-4-1")
    assert(valid_ip_address?('199.255.255.255'), "CASE:2-4-1")
    assert(valid_ip_address?('255.255.255.199'), "CASE:2-4-1")
    assert(valid_ip_address?('255.255.249.255'), "CASE:2-4-1")
    assert(valid_ip_address?('255.255.255.249'), "CASE:2-4-1")
    assert(valid_ip_address?('255.255.255.255'), "CASE:2-4-1")
    # 正常ケース(False)
    assert(!valid_ip_address?(nil), "CASE:2-4-2")
    assert(!valid_ip_address?('255.256.255.255'), "CASE:2-4-3")
    assert(!valid_ip_address?('255.255.255.256'), "CASE:2-4-3")
    assert(!valid_ip_address?('255.255.255.-55'), "CASE:2-4-4")
    assert(!valid_ip_address?('a0.255.255.-55'), "CASE:2-4-4")
    # 異常ケース：なし
  end

  # テスト対象メソッド：check_browser
  test "CASE:2-5 check_browser" do
    # 正常ケース
    chk_result = check_browser('Mozilla/4.0 (compatible; MSIE 4.01; Windows NT)')
    assert(chk_result[0] == 'Internet Explorer', "CASE:2-5-1")
    assert(chk_result[1] == '4', "CASE:2-5-1")
    chk_result = check_browser('Mozilla/4.0 (compatible; MSIE 5.22; Mac_PowerPC)')
    assert(chk_result[0] == 'Internet Explorer', "CASE:2-5-1")
    assert(chk_result[1] == '5', "CASE:2-5-1")
    chk_result = check_browser('Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; ESB{F40811EE-DF17-4BC9-8785-B362ABF34098}; .NET CLR 1.1.4322)')
    assert(chk_result[0] == 'Internet Explorer', "CASE:2-5-1")
    assert(chk_result[1] == '6', "CASE:2-5-1")
    chk_result = check_browser('Mozilla/4.0 (compatible; GoogleToolbar 5.0.2124.2070; Windows 6.0; MSIE 8.0.6001.18241)')
    assert(chk_result[0] == 'Internet Explorer', "CASE:2-5-1")
    assert(chk_result[1] == '8', "CASE:2-5-1")
    chk_result = check_browser('Mozilla/5.0 (Macintosh; U; PPC; ja-JP; rv:0.9.4) Gecko/20011022 Netscape6/6.2')
    assert(chk_result[0] == 'Netscape', "CASE:2-5-2")
    assert(chk_result[1] == '6', "CASE:2-5-2")
    chk_result = check_browser('Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7) Gecko/20040803 Firefox/0.9.3')
    assert(chk_result[0] == 'Firefox', "CASE:2-5-3")
    assert(chk_result[1] == '0', "CASE:2-5-3")
    chk_result = check_browser('Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.5) Gecko/20041116 Firefox/1.0 (Ubuntu) (Ubuntu package 1.0-2ubuntu3)')
    assert(chk_result[0] == 'Firefox', "CASE:2-5-3")
    assert(chk_result[1] == '1', "CASE:2-5-3")
    chk_result = check_browser('Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.0.17) Gecko/2009122116 Firefox/3.0.17 GTB6 (.NET CLR 3.5.30729)')
    assert(chk_result[0] == 'Firefox', "CASE:2-5-3")
    assert(chk_result[1] == '3', "CASE:2-5-3")
    chk_result = check_browser('Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US) AppleWebKit/530.5 (KHTML, like Gecko) Chrome/2.0.172.33 Safari/530.5')
    assert(chk_result[0] == 'Chrome', "CASE:2-5-4")
    assert(chk_result[1] == '2', "CASE:2-5-4")
    chk_result = check_browser('Mozilla/5.0 (Macintosh; U; PPC Mac OS X; nl-nl) AppleWebKit/125.5.5 (KHTML, like Gecko) Safari/125.12')
    assert(chk_result[0] == 'Safari', "CASE:2-5-5")
    assert(chk_result[1] == 'other', "CASE:2-5-5")
    chk_result = check_browser('Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_5_5; ja-jp) AppleWebKit/525.26.2 (KHTML, like Gecko) Version/3.2 Safari/525.26.12')
    assert(chk_result[0] == 'Safari', "CASE:2-5-5")
    assert(chk_result[1] == '3', "CASE:2-5-5")
    chk_result = check_browser('Mozilla/4.0 (compatible; MSIE 5.0; Windows XP) Opera 6.06 [ja]')
    assert(chk_result[0] == 'Opera', "CASE:2-5-6")
    assert(chk_result[1] == '6', "CASE:2-5-6")
    chk_result = check_browser('Mozilla/4.0 (compatible; MSIE 6.0; X11; Linux i686) Opera 7.23 [ja]')
    assert(chk_result[0] == 'Opera', "CASE:2-5-6")
    assert(chk_result[1] == '7', "CASE:2-5-6")
    chk_result = check_browser('Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; en) Opera 9.00')
    assert(chk_result[0] == 'Opera', "CASE:2-5-6")
    assert(chk_result[1] == '9', "CASE:2-5-6")
    chk_result = check_browser('Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; SV1; .NET CLR 1.1.4322; .NET CLR 2.0.50727; InfoPath.1) Sleipnir/2.41')
    assert(chk_result[0] == 'Sleipnir', "CASE:2-5-7")
    assert(chk_result[1] == '2.4', "CASE:2-5-7")
    chk_result = check_browser('Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; .NET CLR 1.1.4322; .NET CLR 2.0.50727; Lunascape 5.0 alpha2)')
    assert(chk_result[0] == 'Lunascape', "CASE:2-5-8")
    assert(chk_result[1] == '5', "CASE:2-5-8")
    chk_result = check_browser('Mozilla/4.0 (compatible; MSIE 6.0; Nitro) Opera 8.50 [ja]')
    assert(chk_result[0] == 'Nintendo DS', "CASE:2-5-9")
    assert(chk_result[1] == '8', "CASE:2-5-9")
    chk_result = check_browser('Opera/9.10 (Nintendo Wii; U; ; 1621; ja)')
    assert(chk_result[0] == 'Wii', "CASE:2-5-10")
    assert(chk_result[1] == '9', "CASE:2-5-10")
    chk_result = check_browser('Mozilla/4.0 (PSP PlayStation Portable); 2.00)')
    assert(chk_result[0] == 'PlayStation Portable', "CASE:2-5-11")
    assert(chk_result[1] == 'other', "CASE:2-5-11")
    chk_result = check_browser('Mozilla/4.0 (PS2; PlayStation BB Navigator 1.0) NetFront/3.0')
    assert(chk_result[0] == 'PlayStation2', "CASE:2-5-12")
    assert(chk_result[1] == 'other', "CASE:2-5-12")
    chk_result = check_browser('Mozilla/5.0 (PLAYSTATION 3; 1.00)')
    assert(chk_result[0] == 'PlayStation3', "CASE:2-5-13")
    assert(chk_result[1] == 'other', "CASE:2-5-13")
    chk_result = check_browser('Mozilla/5.0 (iPod; U; CPU iPhone OS 2_1 like Mac OS X; ja-jp) AppleWebKit/525.18.1 (KHTML, like Gecko) Version/3.1.1 Mobile/5F137 Safari/525.20')
#    print(chk_result[0], ":", chk_result[1], "\n")
    assert(chk_result[0] == 'iPod', "CASE:2-5-14")
    assert(chk_result[1] == 'other', "CASE:2-5-14")
    chk_result = check_browser('Mozilla/5.0 (iPhone; U; CPU like Mac OS X; en) AppleWebKit/420+ (KHTML, like Gecko) Version/3.0 Mobile/1C28 Safari/419.3')
    assert(chk_result[0] == 'iPhone', "CASE:2-5-15")
    assert(chk_result[1] == 'other', "CASE:2-5-15")
    chk_result = check_browser('Mozilla/5.0 (iPhone; U; CPU iPhone OS 2_0 like Mac OS X; ja-jp) AppleWebKit/525.18.1 (KHTML, like Gecko) Version/3.1.1 Mobile/5A345 Safari/525.20')
    assert(chk_result[0] == 'iPhone', "CASE:2-5-15")
    assert(chk_result[1] == 'other', "CASE:2-5-15")
    chk_result = check_browser('Mozilla/5.0 (iPad; U; CPU OS 4_3 like Mac OS X; ja-jp) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8F190 Safari/6533.18.5')
    assert(chk_result[0] == 'iPad', "CASE:2-5-16")
    assert(chk_result[1] == 'other', "CASE:2-5-16")
    chk_result = check_browser('Googlebot/2.1 (+http://www.google.com/bot.html)')
    assert(chk_result[0] == 'Google bot', "CASE:2-5-17")
    assert(chk_result[1] == 'other', "CASE:2-5-17")
    chk_result = check_browser('msnbot/0.3 (+http://search.msn.com/msnbot.htm)')
    assert(chk_result[0] == 'msn bot', "CASE:2-5-18")
    assert(chk_result[1] == 'other', "CASE:2-5-18")
    chk_result = check_browser('librabot/1.0')
    assert(chk_result[0] == 'Microsoft Academic Search bot', "CASE:2-5-18")
    assert(chk_result[1] == 'other', "CASE:2-5-18")
    chk_result = check_browser('Mozilla/5.0 (compatible; Yahoo! Slurp; http://help.yahoo.com/help/us/ysearch/slurp)')
    assert(chk_result[0] == 'Yahoo bot', "CASE:2-5-19")
    assert(chk_result[1] == 'other', "CASE:2-5-19")
    chk_result = check_browser('Baiduspider+(+http://www.baidu.jp/spider/)')
    assert(chk_result[0] == 'Baidu bot', "CASE:2-5-20")
    assert(chk_result[1] == 'other', "CASE:2-5-20")
    chk_result = check_browser('Yeti/1.0 (NHN Corp.; http://help.naver.com/robots/)')
    assert(chk_result[0] == 'Naver bot', "CASE:2-5-21")
    assert(chk_result[1] == 'other', "CASE:2-5-21")
    chk_result = check_browser('Mozilla/4.76 [ja] (X11; U; SunOS 5.8 sun4u)')
    assert(chk_result[0] == 'other', "CASE:2-5-22")
    assert(chk_result[1] == 'other', "CASE:2-5-22")
    # 異常ケース：なし
    chk_result = check_browser(nil)
    assert(chk_result[0] == 'other', "CASE:2-5-23")
    assert(chk_result[1] == 'other', "CASE:2-5-23")
    chk_result = check_browser(100)
    assert(chk_result[0] == 'other', "CASE:2-5-24")
    assert(chk_result[1] == 'other', "CASE:2-5-24")
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

  # テスト対象メソッド：domain_exists?
  test "CASE:2-10 domain_exists?" do
    # 正常ケース
    domain_name = 'infoweb.ne.jp'
    assert(domain_exists?(domain_name), "CASE:2-10-1")
    domain_name = 'yahoo.co.jp'
    assert(domain_exists?(domain_name), "CASE:2-10-1")
    domain_name = 'abc.infoweb.ne.jp'
    assert(!domain_exists?(domain_name), "CASE:2-10-2")
    assert(!domain_exists?(nil), "CASE:2-10-3")
#    print("HOST NAME:", hostname, "\n")
    assert(!domain_exists?(1), "CASE:2-10-4")
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

  # テスト対象メソッド：ex_remote_host
  test "CASE:2-16 ex_remote_host" do
    # 正常ケース
    assert(ex_lang_code('ja') == 'ja', "CASE:2-16-1")
    assert(ex_lang_code('ja, en, en-US') == 'ja', "CASE:2-16-2")
    assert(ex_lang_code('da;DK, en, en-US') == 'da', "CASE:2-16-3")
    assert(ex_lang_code('ja-JP, en, en-US') == 'ja', "CASE:2-16-3")
    assert(ex_lang_code('fr_FR, en, en-US') == 'fr', "CASE:2-16-3")
    # 異常ケース
    assert(ex_lang_code(nil).nil?, "CASE:2-16-4")
    assert(ex_lang_code(1).nil?, "CASE:2-16-4")
  end
end
