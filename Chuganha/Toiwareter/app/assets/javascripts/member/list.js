/**
 * list.js
 * @version   : 1.0.0
 * @author    : 仲観派
 * @license   : The MIT License
 * @modified  : 2013-01-10 09:31
 */
// 会員ホーム表示
function redirect_home(member_id) {
	$("#detail_form").find("#member_id").val(member_id);
	$("#detail_form").submit();
	return false;
};
// バリデーション設定
$(document).ready(function() {
	// バリデーション設定
	$("#search_form").validate({
		errorPlacement: error_placement,
		groups: {
			open_id_grp: "open_id open_id_match",
			member_id_grp: "member_id member_id_match",
			nickname_grp: "nickname nickname_match",
			email_grp: "email email_match",
			quote_cnt_grp: "quote_cnt quote_cnt_comp",
			quote_failure_cnt_grp: "quote_failure_cnt quote_failure_cnt_comp",
			quote_correct_cnt_grp: "quote_correct_cnt quote_correct_cnt_comp",
			quote_correct_failure_cnt_grp: "quote_correct_failure_cnt quote_correct_failure_cnt_comp",
			comment_cnt_grp: "comment_cnt comment_cnt_comp",
			comment_failure_cnt_grp: "comment_failure_cnt comment_failure_cnt_comp",
			comment_report_cnt_grp: "comment_report_cnt comment_report_cnt_comp",
			were_reported_cnt_grp: "were_reported_cnt were_reported_cnt_comp",
			support_report_cnt_grp: "support_report_cnt support_report_cnt_comp",
			sort_cond: "sort_field_1 sort_field_2 sort_order_1 sort_order_2"
		},
		rules: {
			"open_id": {server_err: "#sverr_authority_id", maxlength: 255},
			"member_id": {server_err: "#sverr_member_id", maxlength: 10},
			"nickname": {server_err: "#sverr_nickname", maxlength: 255},
			"email": {server_err: "#sverr_email", maxlength: 255},
			"quote_cnt": {server_err: "#sverr_quote_cnt", maxlength: 8, digits: true},
			"quote_failure_cnt": {server_err: "#sverr_quote_failure_cnt", maxlength: 8, digits: true},
			"quote_correct_cnt": {server_err: "#sverr_quote_correct_cnt", maxlength: 8, digits: true},
			"quote_correct_failure_cnt": {server_err: "#sverr_quote_correct_failure_cnt", maxlength: 8, digits: true},
			"comment_cnt": {server_err: "#sverr_comment_cnt", maxlength: 8, digits: true},
			"comment_failure_cnt": {server_err: "#sverr_comment_failure_cnt", maxlength: 8, digits: true},
			"comment_report_cnt": {server_err: "#sverr_comment_report_cnt", maxlength: 8, digits: true},
			"were_reported_cnt": {server_err: "#sverr_were_reported_cnt", maxlength: 8, digits: true},
			"support_report_cnt": {server_err: "#sverr_support_report_cnt", maxlength: 8, digits: true},
			// 選択項目（ソート条件）
			"sort_field_1": {server_err: "#sverr_sort_cond", hankaku: true, maxlength: 255},
			"sort_field_2": {server_err: "#sverr_sort_cond", hankaku: true, maxlength: 255},
		}
	});
	// バリデーション
	$("#search_form").valid();
});