/**
 * list.js
 * @version   : 1.0.0
 * @author    : 仲観派
 * @license   : The MIT License
 * @modified  : 2013-01-10 09:31
 */
//= require jquery.tablesorter.min
function delete_sub(delete_id) {
	$("#delete_id").val(delete_id);
	$("#delete_form").submit();
	return false;
};
// バリデーション設定
$(document).ready(function() {
	// テーブルソーター
	$("#ng_word_table").tablesorter();
	// バリデーション設定
	$("#create_form").validate({
		errorPlacement: error_placement,
		rules: {
			"ng_word": {server_err: "#sverr_ng_word", required: true, maxlength: 255},
			"replace_word": {server_err: "#sverr_replace_word", required: true, maxlength: 255}
		}
	});
	// バリデーション
	if ($("#sverr_ng_word").val() != null || $("#sverr_ng_word").val() != null) {
		$("#create_form").valid();
	}
});