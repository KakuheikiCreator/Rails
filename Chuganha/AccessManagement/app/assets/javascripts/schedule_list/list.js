/**
 * list.js
 * @version   : 1.0.0
 * @author    : 仲観派
 * @license   : The MIT License
 * @modified  : 2012-08-08 21:50
 */
//= require jquery.tablesorter.min
// フルチェック処理
function full_check(elm){
	var checkbox_elms = $(elm).closest("tr").find("input:checkbox:enabled");
	checkbox_elms.prop("checked", !checkbox_elms.is(':checked'));
}

// チェック処理
function cell_check(event){
	if(!$(event.target).is("td")){return}
	var checkbox_elms = $(this).find("input:checkbox:enabled");
	checkbox_elms.prop("checked", !checkbox_elms.is(':checked'));
}

// フォーム送信処理
function submit_action(selector, action){
	var form_elms = $(selector).parents('form');
	if (form_elms.size() > 0) {
		form_elms.attr("action", './' + action);
		form_elms.submit();
	}
}
// 明細フォーム送信処理（削除）
function delete_action(id){
	var form_elms = $('#delete_id').parents('form');
	if (form_elms.size() > 0) {
		form_elms.find("#delete_id").val(id);
		form_elms.attr("action", './delete');
		form_elms.submit();
	}
}
// 明細フォーム送信処理（更新）
function update_action(elm, id){
	var form_elm = $("#update_form");
	var input_elms = $(elm).closest("tr").find("input");
	form_elm.find("#target_id").val(id);
	input_elms.each(function(){
		var sel_id = "#" + $(this).attr("id");
		form_elm.find(sel_id).val($(this).is(':checked'));
	});
	form_elm.submit();
}
// バリデーション設定
$(document).ready(function() {
	// テーブルソーター設定
	$("#search_result_list").tablesorter();
	// セルクリックイベント背帝
	$("td#click_check").click(cell_check);
	// バリデーション設定
	date_items = "from_datetime[year] from_datetime[month] from_datetime[day] from_datetime[hour] from_datetime[minute] from_datetime[second]"
	           + " to_datetime[year] to_datetime[month] to_datetime[day] to_datetime[hour] to_datetime[minute] to_datetime[second]";
	$("#input_form").validate({
		errorPlacement: error_placement,
		groups: {
			gets_start_date: date_items,
			sort_cond: "sort_item sort_order",
			disp_cond: "disp_counts"
		},
		rules: {
			"system_id": {server_err: "#sverr_system_id"},
			"from_datetime[year]": {server_err: "#sverr_gets_start_date"},
			"from_datetime[month]": {server_err: "#sverr_gets_start_date"},
			"from_datetime[day]": {server_err: "#sverr_gets_start_date"},
			"from_datetime[hour]": {server_err: "#sverr_gets_start_date"},
			"from_datetime[minute]": {server_err: "#sverr_gets_start_date"},
			"from_datetime[second]": {server_err: "#sverr_gets_start_date"},
			"to_datetime[year]": {server_err: "#sverr_gets_start_date"},
			"to_datetime[month]": {server_err: "#sverr_gets_start_date"},
			"to_datetime[day]": {server_err: "#sverr_gets_start_date"},
			"to_datetime[hour]": {server_err: "#sverr_gets_start_date"},
			"to_datetime[minute]": {server_err: "#sverr_gets_start_date"},
			"to_datetime[second]": {server_err: "#sverr_gets_start_date"},
			"sort_item": {required: true, server_err: "#sverr_sort_cond"},
			"sort_order": {required: true, server_err: "#sverr_sort_cond"},
			"disp_counts": {required: true, server_err: "#sverr_disp_cnt_cond"}
		}
	});
	// バリデーション
	$("#input_form").valid();
});