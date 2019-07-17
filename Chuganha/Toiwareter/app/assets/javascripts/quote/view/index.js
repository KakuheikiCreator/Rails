/**
 * index.js
 *
 * @version   : 1.0.0
 * @author    : 仲観派
 * @license   : The MIT License
 * @modified  : 2013-02-10 23:49
 */
//= require jquery.autosize-min
// コメント削除
function open_delete(comment_id) {
	$('#delete_form').find('#comment_id').val(comment_id);
	$('#delete_form').submit();
	return false;
}

// コメント通報
function open_report(comment_id) {
	$('#report_form').find('#comment_id').val(comment_id);
	$('#report_form').submit();
	return false;
}
$(document).ready(function() {
	$('textarea').autosize();
	// バリデーション設定
	$("#comment_form").validate({
		errorPlacement: error_placement,
		rules: {
			"comment": {server_err: "#sverr_comment", required: true, maxlength: 4000}
		}
	});
	if ($("#comment_form").find("#sverr_comment").val() != null) {
		$("#comment_form").valid();
	}
});
