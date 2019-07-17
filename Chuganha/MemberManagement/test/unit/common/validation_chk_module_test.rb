###############################################################################
# ユニットテストクラス
# テスト対象：バリデーションチェックモジュール
# Copyright:: Copyright (c) 2011 仲務省
# 作成日:2011/06/30 Nakanohito  (mailto:)
# 更新日:
###############################################################################
require 'test_helper'

class ValidationChkModuleTest < ActiveSupport::TestCase
  include Common::ValidationChkModule
  # テスト対象メソッド：blank?
  test "CASE:2-1 blank?" do
    # 正常ケース
    assert(blank?(nil), "CASE:2-1-1")
    assert(blank?(""), "CASE:2-1-2")
    assert_equal(blank?(" "), false, "CASE:2-1-3")
    assert_equal(blank?("　"), false, "CASE:2-1-4")
    assert_equal(blank?("hankaku"), false, "CASE:2-1-5")
    assert_equal(blank?("全角文字列"), false, "CASE:2-1-6")
    assert_equal(blank?(20), false, "CASE:2-1-7")
    # 異常ケース
    begin
      blank?({"a"=>"A"})
      flunk("CASE:2-1-8")
    rescue
      assert(true, "CASE:2-1-8")
    end
  end

  # テスト対象メソッド：maxlength?
  test "CASE:2-2 maxlength?" do
    # 正常ケース
    assert(maxlength?(nil, 0), "CASE:2-2-1")
    assert(maxlength?("", 0), "CASE:2-2-2")
    assert(maxlength?("abcｄｅｆghi", 9), "CASE:2-2-3")
    assert(maxlength?("abcｄｅｆghi", 10), "CASE:2-2-4")
    assert_equal(maxlength?("abcｄｅｆghi", 0), false, "CASE:2-2-5")
    assert_equal(maxlength?("abcｄｅｆghi", -1), false, "CASE:2-2-6")
    # 異常ケース
    begin
      maxlength?({"a"=>"A"}, 0)
      flunk("CASE:2-2-7")
    rescue
      assert(true, "CASE:2-2-7")
    end
    begin
      maxlength?("abcｄｅｆghi", {"a"=>"A"})
      flunk("CASE:2-2-8")
    rescue
      assert(true, "CASE:2-2-8")
    end
  end

  # テスト対象メソッド：hankaku?
  test "CASE:2-3 hankaku?" do
    # 正常ケース
    assert(hankaku?(""), "CASE:2-3-1")
    assert(hankaku?("a"), "CASE:2-3-2")
    assert(hankaku?("Z"), "CASE:2-3-2")
    assert(hankaku?("ﾜ"), "CASE:2-3-2")
    assert(hankaku?("-"), "CASE:2-3-2")
    assert(hankaku?("A-Za-z0-9()*@ｱｲｳｴｵ"), "CASE:2-3-3")
    assert_equal(hankaku?(nil), false, "CASE:2-3-4")
    assert_equal(hankaku?("ａ"), false, "CASE:2-3-5")
    assert_equal(hankaku?("５"), false, "CASE:2-3-6")
    assert_equal(hankaku?("abc＊ABC"), false, "CASE:2-3-7")
    # 異常ケース：なし
  end

  # テスト対象メソッド：zenkaku?
  test "CASE:2-4 zenkaku?" do
    # 正常ケース
    assert(zenkaku?(""), "CASE:2-4-1")
    assert(zenkaku?("ａ"), "CASE:2-4-2")
    assert(zenkaku?("Ｚ"), "CASE:2-4-2")
    assert(zenkaku?("ワ"), "CASE:2-4-2")
    assert(zenkaku?("‐"), "CASE:2-4-2")
    assert(zenkaku?("Ａ－Ｚａ－ｚ０－９（）＊＠アイウエオ"), "CASE:2-4-3")
    assert_equal(zenkaku?(nil), false, "CASE:2-4-4")
    assert_equal(zenkaku?("a"), false, "CASE:2-4-5")
    assert_equal(zenkaku?("5"), false, "CASE:2-4-6")
    assert_equal(zenkaku?("abc＊ABC"), false, "CASE:2-4-7")
    # 異常ケース：なし
  end

  # テスト対象メソッド：alphabetic?
  test "CASE:2-5 alphabetic?" do
    # 正常ケース
    assert(alphabetic?(""), "CASE:2-5-1")
    assert(alphabetic?("a"), "CASE:2-5-2")
    assert(alphabetic?("g"), "CASE:2-5-2")
    assert(alphabetic?("z"), "CASE:2-5-2")
    assert(alphabetic?("A"), "CASE:2-5-2")
    assert(alphabetic?("G"), "CASE:2-5-2")
    assert(alphabetic?("Z"), "CASE:2-5-2")
    assert(alphabetic?("aBcDeFgHiJkLmN"), "CASE:2-5-3")
    assert_equal(alphabetic?(nil), false, "CASE:2-5-4")
    assert_equal(alphabetic?("Ａ"), false, "CASE:2-5-5")
    assert_equal(alphabetic?("9"), false, "CASE:2-5-6")
    assert_equal(alphabetic?("-"), false, "CASE:2-5-7")
    # 異常ケース：なし
  end

  # テスト対象メソッド：numeric?
  test "CASE:2-6 numeric?" do
    # 正常ケース
    assert(numeric?(""), "CASE:2-6-1")
    assert(numeric?("0"), "CASE:2-6-2")
    assert(numeric?("5"), "CASE:2-6-2")
    assert(numeric?("9"), "CASE:2-6-2")
    assert(numeric?("3210987654"), "CASE:2-6-3")
    assert_equal(numeric?(nil), false, "CASE:2-6-4")
    assert_equal(numeric?("６"), false, "CASE:2-6-5")
    assert_equal(numeric?("A"), false, "CASE:2-6-6")
    assert_equal(numeric?("+"), false, "CASE:2-6-7")
    # 異常ケース：なし
  end

  # テスト対象メソッド：alphanumeric?
  test "CASE:2-7 alphanumeric?" do
    # 正常ケース
    assert(alphanumeric?(""), "CASE:2-7-1")
    assert(alphanumeric?("a"), "CASE:2-7-2")
    assert(alphanumeric?("m"), "CASE:2-7-2")
    assert(alphanumeric?("z"), "CASE:2-7-2")
    assert(alphanumeric?("A"), "CASE:2-7-2")
    assert(alphanumeric?("M"), "CASE:2-7-2")
    assert(alphanumeric?("Z"), "CASE:2-7-2")
    assert(alphanumeric?("fsNdlJhfsdHih"), "CASE:2-7-3")
    assert(alphanumeric?("0"), "CASE:2-7-4")
    assert(alphanumeric?("6"), "CASE:2-7-4")
    assert(alphanumeric?("9"), "CASE:2-7-4")
    assert(alphanumeric?("7463920"), "CASE:2-7-5")
    assert(alphanumeric?("746Hds39ie2q0"), "CASE:2-7-6")
    assert_equal(alphanumeric?(nil), false, "CASE:2-7-7")
    assert_equal(alphanumeric?("Ｍ"), false, "CASE:2-7-8")
    assert_equal(alphanumeric?("fdskjfoaweＥrhaoewy"), false, "CASE:2-7-9")
    assert_equal(alphanumeric?("７"), false, "CASE:2-7-10")
    assert_equal(alphanumeric?("98２73４008"), false, "CASE:2-7-11")
    assert_equal(alphanumeric?("/"), false, "CASE:2-7-12")
    # 異常ケース：なし
  end

  # テスト対象メソッド：yomigana?
  test "CASE:2-8 yomigana?" do
    # 正常ケース
    assert(yomigana?(""), "CASE:2-8-1")
    assert(yomigana?("ア"), "CASE:2-8-2")
    assert(yomigana?("カ"), "CASE:2-8-2")
    assert(yomigana?("サ"), "CASE:2-8-2")
    assert(yomigana?("タ"), "CASE:2-8-2")
    assert(yomigana?("ナ"), "CASE:2-8-2")
    assert(yomigana?("ン"), "CASE:2-8-2")
    assert(yomigana?("キョモマタヘイタイドモガストーカー"), "CASE:2-8-3")
    assert(yomigana?("・"), "CASE:2-8-4")
    assert(yomigana?("＝"), "CASE:2-8-4")
    assert(yomigana?("クロード・レヴィ＝ストロース"), "CASE:2-8-5")
    assert_equal(yomigana?(nil), false, "CASE:2-8-6")
    assert_equal(yomigana?("ｸﾛｰﾄﾞﾚｳﾞｨｽﾄﾛｰｽ"), false, "CASE:2-8-7")
    assert_equal(yomigana?("ｸﾛｰドﾚｳﾞｨストロｰｽ"), false, "CASE:2-8-8")
    assert_equal(yomigana?("くろーどれびぃすとろーす"), false, "CASE:2-8-9")
    assert_equal(yomigana?("クロード・れびぃ＝ストロース"), false, "CASE:2-8-10")
    # 異常ケース：なし
  end

  # テスト対象メソッド：valid_date?
  test "CASE:2-9 valid_date?" do
    # 正常ケース
    assert(valid_date?(2011, 7, 1), "CASE:2-9-1")
    assert(valid_date?("2011", "07", "01"), "CASE:2-9-1")
    assert(valid_date?(2011, "07", 1), "CASE:2-9-1")
    assert(valid_date?(-1, 7, 1), "CASE:2-9-1")
    assert_equal(valid_date?(nil, 7, 1), false, "CASE:2-9-2")
    assert_equal(valid_date?("", 7, 1), false, "CASE:2-9-2")
    assert_equal(valid_date?(2011, nil, 1), false, "CASE:2-9-3-1")
#    print("20110131:", Date::exist?(2011,1,31), "\n")
#    print("201101-1:", Date::exist?(2011,1,-1), "\n")
#    print("20110132:", Date::exist?(2011,1,32), "\n")
#    print("exist=", Date.exist?(2011, -1, 1).class.name, "\n")
#    print("exist=", Date.exist?(2011, 7, 32), "\n")
#    print("Today:", today.year, "/", today.month, "/", today.day, "\n")
#    print("Return:", Date.exist?(2011, 7, 3), "\n")
#    print("Return:", Date.exist?(-1, 7, 3), "\n")
#    print("Return:", Date.exist?(2011, -1, 1), "\n")
#    print("Return:", Date.exist?(2011, 13, 3), "\n")
#    print("Return:", Date.exist?(2011, 7, -1), "\n")
#    print("Return:", Date.exist?(2011, 7, 32), "\n")
#    print("exist=", Date.exist?(2011, -1, 1).year, "\n")
#    print("exist=", Date.exist?(2011, -1, 1).month, "\n")
#    print("exist=", Date.exist?(2011, -1, 1).day, "\n")
    assert_equal(valid_date?(2011, -1, 1), false, "CASE:2-9-3-2")
    assert_equal(valid_date?(2011, "", 1), false, "CASE:2-9-3-3")
    assert_equal(valid_date?(2011, 7, nil), false, "CASE:2-9-4-1")
    assert_equal(valid_date?(2011, 7, -1), false, "CASE:2-9-4-2")
    assert_equal(valid_date?(2011, 7, 32), false, "CASE:2-9-4-2")
    assert_equal(valid_date?(2011, 7, ""), false, "CASE:2-9-4-3")
    # 異常ケース：なし
  end

  # テスト対象メソッド：past_date?
  test "CASE:2-10 past_date?" do
    # 正常ケース
    today = Date.today
    yesterday = today - 1
    assert(past_date?(yesterday.year.to_i, yesterday.month.to_i, yesterday.day.to_i), "CASE:2-10-1")
    assert(past_date?(yesterday.year.to_s, yesterday.month.to_s, yesterday.day.to_s), "CASE:2-10-1")
    assert(past_date?(yesterday.year.to_i, yesterday.month.to_s, yesterday.day.to_i), "CASE:2-10-1")
    assert(past_date?(-1, 7, 1), "CASE:2-10-1")
    assert_equal(past_date?(today.year.to_i, today.month.to_i, today.day.to_i), false, "CASE:2-10-2")
    assert_equal(past_date?(today.year.to_s, today.month.to_s, today.day.to_s), false, "CASE:2-10-2")
    assert_equal(past_date?(today.year.to_i, today.month.to_i, today.day.to_s), false, "CASE:2-10-2")
    assert_equal(past_date?(nil, 7, 1), false, "CASE:2-10-3")
    assert_equal(past_date?("", 7, 1), false, "CASE:2-10-3")
    assert_equal(past_date?(2011, nil, 1), false, "CASE:2-10-4")
    assert_equal(past_date?(2011, -1, 1), false, "CASE:2-10-4")
    assert_equal(past_date?(2011, "", 1), false, "CASE:2-10-4")
    assert_equal(past_date?(2011, 7, nil), false, "CASE:2-10-5")
    assert_equal(past_date?(2011, 7, -1), false, "CASE:2-10-5")
    assert_equal(past_date?(2011, 7, ""), false, "CASE:2-10-5")
    # 異常ケース：なし
  end

  # テスト対象メソッド：mobile_phone_no?
  test "CASE:2-11 mobile_phone_no?" do
    # 正常ケース
    assert(mobile_phone_no?("070-0123-4567"), "CASE:2-11-1")
    assert(mobile_phone_no?("080-2345-6789"), "CASE:2-11-2")
    assert(mobile_phone_no?("090-0123-4567"), "CASE:2-11-3")
    assert(mobile_phone_no?("07001234567"), "CASE:2-11-4")
    assert_equal(mobile_phone_no?("0700-123-4567"), false, "CASE:2-11-5")
    assert_equal(mobile_phone_no?("08０-2345-6789"), false, "CASE:2-11-6")
    assert_equal(mobile_phone_no?("090-0123-45678"), false, "CASE:2-11-7")
    # 異常ケース：なし
  end

  # テスト対象メソッド：valid_url?
  test "CASE:2-12 valid_url?" do
    # 正常ケース
    assert(valid_url?("http://sankei.jp.msn.com/world/news/110701/amr11070119540012-n1.htm"), "CASE:2-12-1")
    assert(valid_url?("https://login.yahoo.co.jp/config/login?.src=www&.done=http://www.yahoo.co.jp"), "CASE:2-12-2")
    assert(valid_url?("ftp://ftp1.freebsd.org/pub/FreeBSD/"), "CASE:2-12-3")
    assert_equal(valid_url?("nakayan@taihen.com"), false, "CASE:2-12-4")
    assert_equal(valid_url?("htt://sdlfjslid.com/sjdlfsie.png"), false, "CASE:2-12-5")
    # 異常ケース：なし
  end

  # テスト対象メソッド：valid_email?
  test "CASE:2-13 valid_email?" do
    # 正常ケース
    assert(valid_email?("nakayan@taihen.com"), "CASE:2-13-1")
    assert(valid_email?("dankogai+regexp@gmail.com"), "CASE:2-13-1")
    assert_equal(valid_email?("http://sankei.jp.msn.com/world/news/110701/amr11070119540012-n1.htm"), false, "CASE:2-13-2")
    assert_equal(valid_email?("https://login.yahoo.co.jp/config/login?.src=www&.done=http://www.yahoo.co.jp"), false, "CASE:2-13-3")
    assert_equal(valid_email?("ftp://ftp1.freebsd.org/pub/FreeBSD/"), false, "CASE:2-13-4")
    assert_equal(valid_email?("htttp:///sdlfjslid.com/sjdlfsie.png"), false, "CASE:2-13-5")
    assert_equal(valid_email?("da.me..@docomo.ne.jp"), false, "CASE:2-13-5")
    # 異常ケース：なし
  end

  # テスト対象メソッド：valid_type?
  test "CASE:2-14 valid_type?" do
    # 正常ケース
    assert(valid_type?("nakayan@taihen.com", String), "CASE:2-14-1")
    assert(valid_type?(nil, nil), "CASE:2-14-2")
    assert_equal(valid_type?(1, String), false, "CASE:2-14-3")
    assert_equal(valid_type?("1", nil), false, "CASE:2-14-3")
    # 異常ケース：なし
  end

end
