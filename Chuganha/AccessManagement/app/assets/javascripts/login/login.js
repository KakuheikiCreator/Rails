/**
 * login.js
 * @version   : 1.0.0
 * @author    : 仲観派
 * @license   : The MIT License
 * @modified  : 2012-02-26 15:30
 */
// バリデーション設定
$(document).ready(function() {
	// ボタンの角丸め
	$("#login_form_submit").corner();
	// バリデーション設定
	$("#login_form").validate({
		onfocusout: false,
		onclick: false,
		rules: {
			login_id: {required: true},
			password: {required: true}
		}
	});
});