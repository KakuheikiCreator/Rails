/**
 * form.js
 *
 * @version   : 1.0.0
 * @author    : 仲観派
 * @license   : The MIT License
 * @modified  : 2012-12-15 11:40
 */
$(document).ready(function() {
	// バリデーション設定
	$("#update_form").validate({
		errorPlacement: error_placement,
		groups: {
			upd_name: "upd_name_1 upd_name_2",
			upd_name_kana: "upd_name_kana_1 upd_name_kana_2",
			upd_birth: "upd_birth[year] upd_birth[month] upd_birth[day]",
			upd_mobile_email: "upd_mobile_email_local upd_mobile_email_domain",
			upd_gender: "upd_gender"
		},
		rules: {
			"upd_password": {server_err: "#sverr_upd_password", required: true, rangelength: [12, 64], hankaku: true, pw_strength: true},
			"upd_retype_pw": {server_err: "#sverr_upd_retype_pw", required: true, equalTo: "#upd_password"},
			"upd_nickname": {server_err: "#sverr_upd_nickname", required: true, maxlength: 20},
			"upd_name_1": {server_err: "#sverr_upd_name", required: true, maxlength: 20},
			"upd_name_2": {server_err: "#sverr_upd_name", required: true, maxlength: 20},
			"upd_name_kana_1": {server_err: "#sverr_upd_name_kana", required: true, maxlength: 30, yomigana: true},
			"upd_name_kana_2": {server_err: "#sverr_upd_name_kana", required: true, maxlength: 30, yomigana: true},
			"upd_gender": {server_err: "#sverr_upd_gender", required: true},
			// グループ項目（誕生日）
			"upd_birth[year]": {server_err: "#sverr_upd_birth", required: true},
			"upd_birth[month]": {server_err: "#sverr_upd_birth", required: true},
			"upd_birth[day]": {server_err: "#sverr_upd_birth", required: true},
			// 選択項目
			"upd_country": {server_err: "#sverr_upd_country", required: true},
			"upd_language": {server_err: "#sverr_upd_language", required: true},
			"upd_timezone": {server_err: "#sverr_upd_timezone", required: true},
			"upd_postcode": {server_err: "#sverr_upd_postcode", required: true, maxlength: 9, digits: true},
			"upd_email": {server_err: "#sverr_upd_email", required: true, maxlength: 255, email: true},
			"upd_mobile_num": {server_err: "#sverr_upd_mobile_num", required: true, maxlength: 11, cell_phone_number: true},
			"upd_mobile_email_local": {server_err: "#sverr_upd_mobile_email", required: true, maxlength: 220},
			"upd_mobile_email_domain": {server_err: "#sverr_upd_mobile_email", required: true, hankaku: true}
		}
	});
});