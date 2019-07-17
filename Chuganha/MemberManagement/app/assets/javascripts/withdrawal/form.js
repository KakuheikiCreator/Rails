/**
 * form.js
 *
 * @version   : 1.0.0
 * @author    : 仲観派
 * @license   : The MIT License
 * @modified  : 2012-12-31 13:50
 */
$(document).ready(function() {
	// バリデーション設定
	$("#withdrawal_form").validate({
		errorPlacement: error_placement,
		rules: {
			"withdrawal_reason_cls": {server_err: "#sverr_upd_country", required: true},
			"withdrawal_reason_dtl": {server_err: "#sverr_upd_language", maxlength: 2000}
		}
	});
});