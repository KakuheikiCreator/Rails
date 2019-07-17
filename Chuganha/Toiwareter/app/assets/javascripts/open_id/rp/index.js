/**
 * index.js
 * @version   : 1.0.0
 * @author    : 仲観派
 * @license   : The MIT License
 * @modified  : 2012-11-15 20:00
 */
// バリデーション設定
$(document).ready(function() {
	// バリデーション設定
	$("#login_form").validate({
		errorPlacement: error_placement,
		groups: {
			login_fields: "open_id commit"
		},
		rules: {
			"open_id": {required: true}
		}
	});
});