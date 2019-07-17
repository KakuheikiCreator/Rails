/**
 * passsword.js
 *
 * @version   : 1.0.0
 * @author    : 仲観派
 * @copyright : 仲観派
 * @license   : The MIT License
 * @modified  : 2012-02-20 12:00
 */
// パスワード強度チェック
function pw_strength_chk(str_password, min_length) {
	// 言語判定
	var msg_map = password_msg_en, language = navigator.language;
	if (language.length == 0) {language = navigator.browserLanguage;}
	if (language.match('^ja(-JP)?') != null) {msg_map = password_msg_ja;}
	// 未入力判定
	var info ={}
	if (str_password == "") {
		info.score = 0, info.strength = 0;
		info.message = msg_map['not_entered'];
		return info;
	}
	// 最少文字数判定
	if (str_password.split('').length < min_length) {
		info.score = 0, info.strength = 1;
		info.message = msg_map['min_length'];
		return info;
	}
	// 強度判定
	info.score = pw_strength_score(str_password, min_length);
	if (info.score<50) {
		// パスワード強度が低い場合
		info.strength = 2;
		info.message = msg_map['weak'];
	} else if (info.score>=50 && info.score<75) {
		// パスワード強度が中程度
		info.strength = 3;
		info.message = msg_map['strong'];
	} else if (info.score>=75 && info.score<100) {
		// パスワード強度が強程度
		info.strength = 4;
		info.message = msg_map['stronger'];
	} else {
		// パスワード強度が最強程度
		info.strength = 5;
		info.message = msg_map['stronges'];
	}
	return info;
}
// パスワード強度スコア算出
function pw_strength_score(str_password, min_length){
	// 変数宣言
	var num = {};
	num.excess = 0;		// 強度計算用変数（超過文字数）
	num.upper = 0;		// 強度計算用変数（英大文字数）
	num.numbers = 0;	// 強度計算用変数（数字数）
	num.symbols = 0;	// 強度計算用変数（記号文字数）
	var bonus = {};
	bonus.excess = 3;	// 強度計算用ボーナス値（超過文字数）
	bonus.upper = 3;	// 強度計算用ボーナス値（英大文字数）
	bonus.numbers = 4;	// 強度計算用ボーナス値（数字数）
	bonus.symbols = 4;	// 強度計算用ボーナス値（記号文字数）
	bonus.combo = 0;	// 強度計算用ボーナス値（組み合わせ）
	bonus.flat_lower = 0;	// 強度計算用ボーナス値（英小文字未存在）
	bonus.flat_number = 0;	// 強度計算用ボーナス値（数字未存在）
	// パスワード文字数判定
	if (str_password.split('').length < min_length) {return 0;}
	// パスワード解析
	pw_analyzeString(str_password, min_length, num, bonus);
	// パスワード強度計算
	return pw_calcComplexity(num, bonus);
}
// パスワード解析
function pw_analyzeString (str_password, min_length, num, bonus) {
	var charPassword = str_password.split('');
	for (i=0; i<charPassword.length;i++) {
		if (charPassword[i].match(/[A-Z]/g)) {num.upper++;}		// 英大文字数カウントアップ
		if (charPassword[i].match(/[0-9]/g)) {num.numbers++;}	// 数字数カウントアップ
		if (charPassword[i].match(/[.,+\-*\/!"#$%&'\(\)=~^|\\@{}\[\]<>?_]/)) {num.symbols++;}	// 記号文字数カウントアップ
	}
	// 最少文字数を超えた分の文字数カウント
	num.excess = charPassword.length - min_length;
	if (num.upper && num.numbers && num.symbols) {
		// カウントした各文字数が全て0以外
		bonus.combo = 25;
	} else if ((num.upper && num.numbers) || (num.upper && num.symbols) || (num.numbers && num.symbols)) {
		// カウントした文字数の二つの組み合わせが共に0以外
		bonus.combo = 15;
	}
	// 空白文字と英小文字のみかチェック
	if (str_password.match(/^[\sa-z]+$/)) {
		bonus.FlatLower = -15;
	}
	// 空白文字と数字のみかチェック
	if (str_password.match(/^[\s0-9]+$/)) {
		bonus.flat_number = -35;
	}
}
// パスワード強度スコア計算
function pw_calcComplexity(num, bonus) {
	var baseScore = 45;	// 基本強度スコア
	return baseScore + (num.excess*bonus.excess) + (num.upper*bonus.upper) +
					   (num.numbers*bonus.numbers) + (num.symbols*bonus.symbols) +
					   bonus.combo + bonus.flat_lower + bonus.flat_number;
}
// メッセージマップ
var password_msg_en = {
  not_entered: "Please enter your password.",
  min_length: "Password length is not enough.",
  weak: "Password strength(Weak!)",
  strong: "Password strength(Average!)",
  stronger: "Password strength(Strong!)",
  stronges: "Password strength(Secure!)"
};
var password_msg_ja = {
  not_entered: "パスワードを入力してください。",
  min_length: "パスワード文字数が足りません",
  weak: "パスワード強度（低）",
  strong: "パスワード強度（中）",
  stronger: "パスワード強度（強）",
  stronges: "パスワード強度（最強）"
};