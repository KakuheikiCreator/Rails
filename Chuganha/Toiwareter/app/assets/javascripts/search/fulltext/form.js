/**
 * form.js
 *
 * @version   : 1.0.0
 * @author    : 仲観派
 * @license   : The MIT License
 * @modified  : 2013-02-10 23:49
 */
//= require jquery.autosize-min
// 引用表示
function open_quote(quote_id) {
	$('#quote_form').find('#quote_id').val(quote_id);
	$('#quote_form').submit();
	return false;
}

$(document).ready(function() {
	$('textarea').autosize();
	// バリデーション設定
	$("#quote_search_form").validate({
		errorPlacement: error_placement,
		rules: {
			"quote": {server_err: "#sverr_quote", required: true, maxlength: 400}
		}
	});
	$("#comment_search_form").validate({
		errorPlacement: error_placement,
		rules: {
			"comment": {server_err: "#sverr_comment", required: true, maxlength: 400}
		}
	});
});
