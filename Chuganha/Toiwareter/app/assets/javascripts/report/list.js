/**
 * list.js
 *
 * @version   : 1.0.0
 * @author    : 仲観派
 * @license   : The MIT License
 * @modified  : 2013-01-23 23:49
 */
// コメント削除フォーム表示
function del_form(comment_id) {
	$("#delete_form").find("#comment_id").val(comment_id);
	$("#delete_form").submit();
	return false;
};
$(document).ready(function() {
	set_action_handler();
	// バリデーション設定
	$("#search_form").validate({
		errorPlacement: error_placement,
		groups: {
			quote_id_grp: "quote_id quote_id_comp",
			comment_id_grp: "comment_id comment_id_comp",
			report_date_grp: "report_date[year] report_date[month] report_date[day] report_date[hour] report_date[minute] report_date[second]",
			report_reason_grp: "report_reason_detail report_reason_match",
			report_member_id_grp: "report_member_id report_member_match",
			report_nickname_grp: "report_nickname report_nickname_match",
			comment_member_id_grp: "comment_member_id comment_member_match",
			comment_nickname_grp: "comment_nickname comment_nickname_match",
			sort_limit_fields_grp: "sort_field_1 sort_field_2 sort_order_1 sort_order_2 display_count",
		},
		rules: {
			"quote_id": {server_err: "#sverr_quote_id", number: true},
			"comment_id": {server_err: "#sverr_comment_id", number: true},
			"comment_member_id": {server_err: "#sverr_comment_member_id", maxlength: 10},
			"comment_nickname": {server_err: "#sverr_comment_nickname", maxlength: 255},
			"report_reason_id": {server_err: "#sverr_report_reason_id", number: true},
			"report_reason_detail": {server_err: "#sverr_report_reason_detail", maxlength: 255},
			"report_member_id": {server_err: "#sverr_report_member_id", maxlength: 10},
			"report_nickname": {server_err: "#sverr_report_nickname", maxlength: 255},
			// 選択項目（ソート条件）
			"sort_field_1": {server_err: "#sverr_sort_cond", hankaku: true, maxlength: 255},
			"sort_field_2": {server_err: "#sverr_sort_cond", hankaku: true, maxlength: 255},
		}
	});
});
