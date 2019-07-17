/**
 * list.js
 *
 * @version   : 1.0.0
 * @author    : 仲観派
 * @license   : The MIT License
 * @modified  : 2012-12-21 17:24
 */
function submit_home(user_id) {
	$("#user_id").val(user_id);
	$("#list_form").submit();
};
$(document).ready(function() {
	// バリデーション設定
	$("#search_form").validate({
		errorPlacement: error_placement,
		groups: {
			cond_user_id_grp: "cond_user_id cond_user_id_match",
			cond_nickname_grp: "cond_nickname cond_nickname_match",
			cond_name: "cond_last_name cond_first_name cond_name_match",
			cond_yomigana: "cond_yomigana_last cond_yomigana_first cond_yomigana_match",
			cond_postcode_grp: "cond_postcode cond_postcode_match",
			cond_email_grp: "cond_email cond_email_match",
			cond_mobile_num: "cond_mobile_phone_no cond_mbl_num_match",
			cond_mobile_id: "cond_mobile_id_no cond_mbl_id_match",
			cond_mobile_email_grp: "cond_mobile_email cond_mbl_email_match",
			sort_cond: "sort_field_1 sort_field_2 sort_field_3 sort_order_1 sort_order_2 sort_order_3"
		},
		rules: {
			"cond_user_id": {server_err: "#sverr_cond_user_id", maxlength: 32},
			"cond_nickname": {server_err: "#sverr_cond_nickname", maxlength: 40},
			"cond_last_name": {server_err: "#sverr_cond_name", maxlength: 20},
			"cond_first_name": {server_err: "#sverr_cond_name", maxlength: 20},
			"cond_yomigana_last": {server_err: "#sverr_cond_yomigana", maxlength: 30, yomigana: true},
			"cond_yomigana_first": {server_err: "#sverr_cond_yomigana", maxlength: 30, yomigana: true},
			"cond_email": {server_err: "#sverr_cond_email", maxlength: 255},
			"cond_postcode": {server_err: "#sverr_cond_postcode", maxlength: 9, digits: true},
			"cond_mobile_phone_no": {server_err: "#sverr_cond_mobile_num", maxlength: 11, digits: true},
			"cond_mobile_id_no": {server_err: "#sverr_cond_mobile_id_no", maxlength: 255},
			"cond_mobile_email": {server_err: "#sverr_cond_mobile_email", maxlength: 255},
			// 選択項目（ソート条件）
			"sort_field_1": {server_err: "#sverr_sort_cond", hankaku: true, maxlength: 255},
			"sort_field_2": {server_err: "#sverr_sort_cond", hankaku: true, maxlength: 255},
			"sort_field_3": {server_err: "#sverr_sort_cond", hankaku: true, maxlength: 255}
		}
	});
	// バリデーション
	$("#search_form").valid();
});