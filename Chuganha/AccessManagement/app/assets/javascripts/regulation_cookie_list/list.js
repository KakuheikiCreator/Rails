/**
 * list.js
 * @version   : 1.0.0
 * @author    : 仲観派
 * @license   : The MIT License
 * @modified  : 2012-02-26 15:30
 */
// フォーム送信処理
function submit_action(selector, action){
	var form_elms = $(selector).parents('form');
	if (form_elms.size() > 0) {
		form_elms.attr("action", './' + action);
		form_elms.submit();
	}
}
// 削除フォーム送信処理
function delete_action(selector, id){
	var form_elms = $(selector).parents('form');
	if (form_elms.size() > 0) {
		form_elms.find("#delete_id").val(id);
		form_elms.submit();
	}
}
// バリデーション設定
$(document).ready(function() {
	// テーブルソーター設定
	$("#search_result_list").tablesorter();
	// バリデーション設定
	$("#input_form").validate({
		errorPlacement: error_placement,
		groups: {
			sort_cond: "sort_item sort_order",
			disp_cond: "disp_counts"
		},
		rules: {
			"regulation_cookie[system_id]": {server_err: "#sverr_system_id"},
			"regulation_cookie[cookie]": {server_err: "#sverr_cookie", maxlength: 1024},
			"regulation_cookie[remarks]": {server_err: "#sverr_remarks", maxlength: 255},
			"sort_item": {server_err: "#sverr_sort_cond"},
			"sort_order": {server_err: "#sverr_sort_cond"},
			"disp_counts": {server_err: "#sverr_disp_cnt_cond"}
		}
	});
	// バリデーション
	$("#input_form").valid();
});