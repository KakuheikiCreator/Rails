/**
 * form.js
 * @version   : 1.0.0
 * @author    : 仲観派
 * @license   : The MIT License
 * @modified  : 2013-01-10 09:31
 */
// バリデーション設定
$(document).ready(function() {
	// バリデーション設定
	$("#register_form").validate({
		errorPlacement: error_placement,
		rules: {
			"open_id": {server_err: "#sverr_open_id", required: true, maxlength: 255, hankaku: true},
			"nickname": {server_err: "#sverr_nickname", required: true, maxlength: 255},
			"email": {server_err: "#sverr_email", required: true, maxlength: 255, email: true},
			"agreement": {server_err: "#sverr_agreement", required: true}
		}
	});
});