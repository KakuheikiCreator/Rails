/**
 * application.js
 *
 * @version   : 1.0.0
 * @author    : 仲観派
 * @license   : The MIT License
 * @modified  : 2012-02-20 20:40
 */



//#############################################################################
// バリデーション関連メソッド定義
//#############################################################################
// バリデーションメッセージ辞書
var validator_msg_ja = {
  required: "このフィールドは必須です。",
  remote: "このフィールドを修正してください。",
  email: "有効なEメールアドレスを入力してください。",
  url: "有効なURLを入力してください。",
  date: "有効な日付を入力してください。",
  dateISO: "有効な日付（ISO）を入力してください。",
  number: "数値を入力してください。",
  digits: "数字を入力してください。",
  creditcard: "有効なクレジットカード番号を入力してください。",
  equalTo: "同じ値をもう一度入力してください。",
  accept: "有効な拡張子を含む値を入力してください。",
  maxlength: jQuery.format("{0} 文字以内で入力してください。"),
  minlength: jQuery.format("{0} 文字以上で入力してください。"),
  rangelength: jQuery.format("{0} 文字から {1} 文字までの値を入力してください。"),
  range: jQuery.format("{0} から {1} までの値を入力してください。"),
  max: jQuery.format("{0} 以下の値を入力してください。"),
  min: jQuery.format("{0} 以上の値を入力してください。"),
  vaild_length: jQuery.format("{0} 文字の値を入力してください。"),
  hankaku: "半角文字を入力してください。",
  zenkaku: "全角文字を入力してください。",
  alphabetic: "半角英字を入力してください。",
  alphanumeric: "半角英数字を入力してください。",
  yomigana: "ヨミガナ（カタカナ、・、＝、ー）を入力してください。",
  ex_date: "有効な日付を入力してください。",
  past_date: "有効な過去の日付を入力してください。",
  zip_code: "有効な郵便番号を入力してください。",
  tel_number: "有効な電話番号を入力してください。",
  cell_phone_number: "有効な携帯電話番号を入力してください。",
  ex_email: "有効なEメールアドレスを入力してください。",
  pw_strength: "より高い強度のパスワードを入力してください。"
};
// 文字数チェック
function is_valid_length(val, length){
	if(typeof(val) != 'string'){return false;}
	return val.split('').length == length;
};
// 半角チェック
function is_hankaku(val){
	if(typeof(val) != 'string'){return false;}
	for(var i=0; i < val.length; i++){
		if(escape(val.charAt(i)).length > 4){return false;}
	}
	return true;
};
// 全角チェック
function is_zenkaku(val){
	if(typeof(val) != 'string'){return false;}
	for(var i=0; i < val.length; i++){
		if(escape(val.charAt(i)).length <= 4){return false;}
	}
	return true;
};
// 半角英字チェック
function is_alphabetic(val){
	if(typeof(val) != 'string'){return false;}
	return (val.match(/^[a-zA-Z]+$/g) == val);
};
// 半角数字チェック
function is_numeric(val){
	var type = typeof(val)
	if(type != 'string' && type != 'number'){return false;}
	return (('' + val).match(/^\d+$/g) == val);
};
// 半角英数字チェック
function is_alphanumeric(val){
	if(typeof(val) != 'string'){return false;}
	return (val.match(/^[0-9a-zA-Z]+$/g) == val);
};
// ヨミガナチェック
function is_yomigana(val){
	if(typeof(val) != 'string'){return false;}
	return (val.match(/^[ァ-ヶ・＝ー]+$/g) == val);
};
// 日付妥当性チェック
function is_valid_date(year, month, day){
	var dt = new Date(year, month - 1, day);
	return (dt.getFullYear() == year && dt.getMonth() + 1 == month && dt.getDate() == day);
};
// 過去日付チェック
function is_past_date(year, month, day){
	if(!is_valid_date(year, month, day)) {return false;}
	now = new Date();
	return (new Date(year, month - 1, day) < new Date(now.getFullYear(), now.getMonth(), now.getDate()));
};
// 郵便番号チェック
function is_postal_code(val){
	if(typeof(val) != 'string'){return false;}
	return (val.match(/^\d{3}-?\d{4}$/) == val);
};
// 電話番号チェック
function is_tel(val){
	if(typeof(val) != 'string'){return false;}
	var len = val.replace(/-/, '').length;
	return (val.match(/^\d{2,4}-?\d{2,4}-?\d{4}$/) == val);
};
// 携帯電話番号チェック
function is_cellular(val){
	if(typeof(val) != 'string'){return false;}
	return (val.match(/^0[7-9]0-?\d{4}-?\d{4}$/) == val);
};
// メールアドレス書式チェック
function is_valid_mail(val){
	if(typeof(val) != 'string'){return false;}
	return (val.match(/^(?:(?:(?:(?:[a-zA-Z0-9_!#\$\%&'*+\/=?\^`{}~|\-]+)(?:\.(?:[a-zA-Z0-9_!#\$\%&'*+\/=?\^`{}~|\-]+))*)|(?:"(?:\\[^\r\n]|[^\\"])*")))\@(?:(?:(?:(?:[a-zA-Z0-9_!#\$\%&'*+\/=?\^`{}~|\-]+)(?:\.(?:[a-zA-Z0-9_!#\$\%&'*+\/=?\^`{}~|\-]+))*)|(?:\[(?:\\\S|[\x21-\x5a\x5e-\x7e])*\])))$/) == val);
};
// バリデーションメッセージ辞書設定
function set_validator_msg() {
  var language = navigator.language;
  if (language.length == 0) {language = navigator.browserLanguage;}
  if (language.match('^ja(-JP)?') != null) {jQuery.extend(jQuery.validator.messages, validator_msg_ja);}
};
//#############################################################################
// バリデーション処理エントリー
//#############################################################################
// バリデーションデフォルト設定
jQuery.validator.setDefaults({
	errorClass: "validation_error"
});
// バリデーションメソッド追加（文字数チェック）
jQuery.validator.addMethod("vaild_length",
function(value, element, params) {
	return this.optional(element) || is_valid_length(value, params);
}, $.validator.format("Please enter a value of {0} characters."));
// バリデーションメソッド追加（半角チェック）
jQuery.validator.addMethod("hankaku",
function(value, element) {
	return this.optional(element) || is_hankaku(value);
}, "Please enter a valid single-byte characters.");
// バリデーションメソッド追加（全角チェック）
jQuery.validator.addMethod("zenkaku",
function(value, element) {
	return this.optional(element) || is_zenkaku(value);
}, "Please enter a valid double-byte characters.");
// バリデーションメソッド追加（英字チェック）
jQuery.validator.addMethod("alphabetic",
function(value, element) {
	return this.optional(element) || is_alphabetic(value);
}, "Please enter a valid alphabetic characters.");
// バリデーションメソッド追加（英数字チェック）
jQuery.validator.addMethod("alphanumeric",
function(value, element) {
	return this.optional(element) || is_alphanumeric(value);
}, "Please enter a valid alphanumeric characters.");
// バリデーションメソッド追加（ヨミガナチェック）
jQuery.validator.addMethod("yomigana",
function(value, element) {
	return this.optional(element) || is_yomigana(value);
}, "Please enter a valid pseudonym reading(katakana).");
// バリデーションメソッド追加（拡張日付妥当性チェック）
jQuery.validator.addMethod("ex_date",
function(value, element) {
	var parent_elm = $(element).parent('.chkgroup'), year, month, day;
	if (parent_elm.size() == 0) {
		split_vals = value.split('/', 3);
		year = split_vals[0], month = split_vals[1], day = split_vals[2];
	} else {
		var children = parent_elm.children('input');
		year = children[0].value, month = children[1].value, day = children[2].value;
	}
	return this.optional(element) || is_valid_date(year, month, day);
}, "Please enter a valid date.");
// バリデーションメソッド追加（拡張過去日付チェック）
jQuery.validator.addMethod("past_date",
function(value, element) {
	var parent_elm = $(element).parent('.chkgroup'), year, month, day;
	if (parent_elm.size() == 0) {
		split_vals = value.split('/', 3);
		year = split_vals[0], month = split_vals[1], day = split_vals[2];
	} else {
		var children = parent_elm.children('input');
		year = children[0].value, month = children[1].value, day = children[2].value;
	}
	return this.optional(element) || is_past_date(year, month, day);
}, "Please enter a valid date in the past.");
// バリデーションメソッド追加（拡張郵便番号チェック）
jQuery.validator.addMethod("zip_code",
function(value, element) {
	var parent_elm = $(element).parent('.chkgroup'), zip_code = value;
	if (parent_elm.size() == 1) {
		var children = parent_elm.children('input');
		zip_code = children[0].value + children[1].value;
	}
	return this.optional(element) || is_postal_code(zip_code);
}, "Please enter a valid ZIP code.");
// バリデーションメソッド追加（電話番号チェック）
jQuery.validator.addMethod("tel_number",
function(value, element) {
	var parent_elm = $(element).parent('.chkgroup'), tel_number = value;
	if (parent_elm.size() == 1) {
		var children = parent_elm.children('input');
		tel_number = children[0].value + '-' + children[1].value + '-' + children[2].value;
	}
	return this.optional(element) || is_tel(tel_number);
}, "Please enter a valid phone number.");
// バリデーションメソッド追加（携帯電話番号チェック）
jQuery.validator.addMethod("cell_phone_number",
function(value, element) {
	var parent_elm = $(element).parent('.chkgroup'), cellular_number = value;
	if (parent_elm.size() == 1) {
		var children = parent_elm.children('input');
		cellular_number = children[0].value + '-' + children[1].value + '-' + children[2].value;
	}
	return this.optional(element) || is_cellular(cellular_number);
}, "Please enter a valid cell-phone number.");
// バリデーションメソッド追加（拡張メールチェック）
jQuery.validator.addMethod("ex_email",
function(value, element) {
	var email = value;
	var parent_elm = $(element).parent('.chkgroup');
	if (parent_elm.size() == 1) {
		var children = parent_elm.children('input');
		email = children.val() + '@' + children.next().val();
	}
	return this.optional(element) || is_valid_mail(email);
}, "Please enter a valid email address.");
// バリデーションメソッド追加（サーバー側エラーチェック）
jQuery.validator.addMethod("server_err",
function(value, element, params) {
	var hidden_elm_sel = params;
	if (hidden_elm_sel == true) {hidden_elm_sel = '[name="sverr_' + element.name + '"]';}
	var hidden_elm = $(hidden_elm_sel);
	return (hidden_elm.size() == 0 || hidden_elm.attr("name") == ""); 
},
function(params, element){
	var hidden_elm_sel = params;
	if (hidden_elm_sel == true) {hidden_elm_sel = '[name="sverr_' + element.name + '"]';}
	var hidden_elm = $(hidden_elm_sel);
	hidden_elm.attr("name", "");
	return hidden_elm.val();
});
// バリデーションメソッド追加（パスワード強度チェック）
jQuery.validator.addMethod("pw_strength",
function(value, element, params) {
	var pw_length = params;
	if (!is_numeric(pw_length)) {pw_length = 8};
	var strength_info = pw_strength_chk(value, pw_length);
	return this.optional(element) || (strength_info.strength >= 4);
}, "Please enter the password for the higher intensity.");
// バリデーションエラーメッセージ表示場所設定
var error_placement = function(error, element) {
	parent_elm = element.parent('.chkgroup');
	if (parent_elm.size() == 1) {
		error.insertAfter(parent_elm);
	} else {
		error.insertAfter(element);
	}
};
// バリデーションメッセージ辞書設定
set_validator_msg();

//#############################################################################
// ajax関係
//#############################################################################
function scr_trans_params(selector){
	return {
	'screen_transition_pattern': $(selector).find('#screen_transition_pattern').val(),
	'function_transition_no': $(selector).find('#function_transition_no').val(),
	'synchronous_token': $(selector).find('#synchronous_token').val()
	}
}
$.ajaxSetup({
	async: true,
	type: "POST"
});

//#############################################################################
// フォームコントローラー制御
//#############################################################################
// フォーム送信処理
function submit_form(selector, target){
	var form_elms = $(selector).parents('form');
	if (form_elms.size() > 0) {
		var before_target = form_elms.attr("target");
		var scr_tran_ptn = form_elms.find("#screen_transition_pattern");
		var before_ptn = scr_tran_ptn.val();
		if (target != "_self" && before_ptn == '1') {
			scr_tran_ptn.val('2');
		}
		form_elms.attr("target", target);
		form_elms.submit();
		form_elms.attr("target", before_target);
		scr_tran_ptn.val(before_ptn);
	}
}
// フォームクリア処理
function clear_form(elm){
	var form_elm = $(elm).closest("form");
	var target_elms = form_elm.find('input[type="text"], input[type="checkbox"], input[type="radio"], select, textarea');
	target_elms.val('');
}
//#############################################################################
// コンテキストメニュー関係
//#############################################################################
// コンテキストメニュースタイル
jQuery.contextMenu.defaults({
	menuStyle : {
		listStyle: 'none',
		padding: '1px',
		margin: '0px',
		backgroundColor: '#fff',
		border: '1px solid #000',
		width: '200px'
	},
	itemStyle: {
		margin: '0px',
		padding: '2px',
		display: 'block',
		cursor: 'default',
		border: '1px solid #000',
		color: '#000',
		backgroundColor : '#fff',
	},
	itemHoverStyle: {
		border: '1px solid #0a246a',
		backgroundColor: '#b6bdd2'
	}
});
