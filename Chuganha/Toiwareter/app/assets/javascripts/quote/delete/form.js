/**
 * form.js
 *
 * @version   : 1.0.0
 * @author    : 仲観派
 * @license   : The MIT License
 * @modified  : 2013-02-17 00:10
 */
//= require jquery.autosize-min
// コメント通報
function return_to_quote() {
	$("#return_form").submit();
	return false;
}
$(document).ready(function() {
	$("textarea").autosize();
	// バリデーション設定
	$("#delete_form").validate({
		errorPlacement: error_placement,
		rules: {
			"delete_reason_id": {server_err: "#sverr_delete_reason_id", required: true},
			"delete_reason_detail": {server_err: "#sverr_delete_reason_detail", required: true, maxlength: 2000}
		}
	});
});
