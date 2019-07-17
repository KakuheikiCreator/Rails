/**
 * login.js
 *
 * @version   : 1.0.0
 * @author    : 仲観派
 * @license   : The MIT License
 * @modified  : 2012-11-24 21:40
 */
$(document).ready(function() {
	// バリデーション設定
	$("#login_form").validate({
		errorPlacement: error_placement,
		rules: {
			"open_id": {server_err: "#sverr_open_id", required: true, maxlength: 255, hankaku: true},
			"password": {server_err: "#sverr_password", required: true, rangelength: [12, 64], hankaku: true}
		}
	});
});