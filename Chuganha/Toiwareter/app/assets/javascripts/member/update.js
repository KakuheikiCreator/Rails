/**
 * update.js
 * @version   : 1.0.0
 * @author    : 仲観派
 * @license   : The MIT License
 * @modified  : 2013-01-22 03:10
 */
// バリデーション設定
$(document).ready(function() {
	// バリデーション設定
	$("#update_form").validate({
		errorPlacement: error_placement,
		rules: {
			"nickname": {server_err: "#sverr_nickname", maxlength: 255},
			"email": {server_err: "#sverr_email", maxlength: 255, ex_email: true},
			"quote_cnt": {server_err: "#sverr_quote_cnt", maxlength: 8, digits: true},
			"quote_failure_cnt": {server_err: "#sverr_quote_failure_cnt", maxlength: 8, digits: true},
			"quote_correct_cnt": {server_err: "#sverr_quote_correct_cnt", maxlength: 8, digits: true},
			"quote_correct_failure_cnt": {server_err: "#sverr_quote_correct_failure_cnt", maxlength: 8, digits: true},
			"comment_cnt": {server_err: "#sverr_comment_cnt", maxlength: 8, digits: true},
			"comment_failure_cnt": {server_err: "#sverr_comment_failure_cnt", maxlength: 8, digits: true},
			"comment_report_cnt": {server_err: "#sverr_comment_report_cnt", maxlength: 8, digits: true},
			"were_reported_cnt": {server_err: "#sverr_were_reported_cnt", maxlength: 8, digits: true},
			"support_report_cnt": {server_err: "#sverr_support_report_cnt", maxlength: 8, digits: true}
		}
	});
	// バリデーション
	$("#update_form").valid();
});