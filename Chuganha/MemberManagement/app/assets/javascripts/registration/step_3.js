/**
 * step_3.js
 *
 * @version   : 1.0.0
 * @author    : 仲観派
 * @license   : The MIT License
 * @modified  : 2012-11-24 21:40
 */
$(document).ready(function() {
	// OpenID存在チェック
	$("#check_id_btn").click(function(){
		params = scr_trans_params('#step_3_form');
		params['check_user_id'] = $("#identifier").val();
		$('#check_id_result').load('check_id', params);
		return false;
	});
	// バリデーション設定
	$("#step_3_form").validate({
		errorPlacement: error_placement,
		groups: {
			name: "name_1 name_2",
			name_kana: "name_kana_1 name_kana_2",
			birth: "birth[year] birth[month] birth[day]",
			mobile_email: "mobile_email_local mobile_email_domain",
			gender: "gender"
		},
		rules: {
			"identifier": {server_err: "#sverr_identifier", required: true, maxlength: 32, hankaku: true},
			"password": {server_err: "#sverr_password", required: true, rangelength: [12, 64], hankaku: true, pw_strength: true},
			"retype_pw": {server_err: "#sverr_retype_pw", required: true, equalTo: "#password"},
			"nickname": {server_err: "#sverr_nickname", required: true, maxlength: 20},
			"name_1": {server_err: "#sverr_name", required: true, maxlength: 20},
			"name_2": {server_err: "#sverr_name", required: true, maxlength: 20},
			"name_kana_1": {server_err: "#sverr_name_kana", required: true, maxlength: 30, yomigana: true},
			"name_kana_2": {server_err: "#sverr_name_kana", required: true, maxlength: 30, yomigana: true},
			"gender": {server_err: "#sverr_gender", required: true},
			// グループ項目（誕生日）
			"birth[year]": {server_err: "#sverr_birth", required: true},
			"birth[month]": {server_err: "#sverr_birth", required: true},
			"birth[day]": {server_err: "#sverr_birth", required: true},
			// 選択項目
			"country": {server_err: "#sverr_country", required: true},
			"language": {server_err: "#sverr_language", required: true},
			"timezone": {server_err: "#sverr_timezone", required: true},
			"postcode": {server_err: "#sverr_postcode", required: true, maxlength: 9, digits: true},
			"email": {server_err: "#sverr_email", required: true, maxlength: 255, email: true},
			"mobile_num": {server_err: "#sverr_mobile_num", required: true, maxlength: 11, cell_phone_number: true},
			"mobile_email_local": {server_err: "#sverr_mobile_email", required: true, maxlength: 220},
			"mobile_email_domain": {server_err: "#sverr_mobile_email", required: true, hankaku: true}
		}
	});
});