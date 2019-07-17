/**
 * form.js
 *
 * @version   : 1.0.0
 * @author    : 仲観派
 * @license   : The MIT License
 * @modified  : 2013-03-04 23:49
 */
//= require jquery.autosize-min
// 引用表示
function open_quote(quote_id) {
	$('#quote_form').find('#quote_id').val(quote_id);
	submit_new_window('#quote_form');
	return false;
}

$(document).ready(function() {
	$('textarea').autosize();
	// バリデーション設定（引用）
	$("#quote_search_form").validate({
		errorPlacement: error_placement,
		groups: {
			speaker_job_title_grp: "speaker_job_title_id speaker_job_title",
			registered_date_grp: "registered_date[year] registered_date[month] registered_date[day] registered_date[hour] registered_date[minute] registered_date[second], registered_date_comp"
		},
		rules: {
			"quote": {server_err: "#sverr_quote", maxlength: 400},
			"speaker": {server_err: "#sverr_speaker", maxlength: 60},
			"speaker_job_title_id": {server_err: "#sverr_speaker_job_title", number: true},
			"speaker_job_title": {server_err: "#sverr_speaker_job_title", maxlength: 40},
			"description": {server_err: "#sverr_description", maxlength: 2000},
			"registered_member": {server_err: "#sverr_registered_member", maxlength: 60},
			"update_member": {server_err: "#sverr_update_member", maxlength: 60},
			"registered_date[year]": {server_err: "#sverr_registered_date"}
		}
	});
	$("#quote_search_form").valid();
	// バリデーション設定（コメント）
	$("#comment_search_form").validate({
		errorPlacement: error_placement,
		groups: {
			criticism_date_grp: "criticism_date[year] criticism_date[month] criticism_date[day] criticism_date[hour] criticism_date[minute] criticism_date[second], criticism_date_comp"
		},
		rules: {
			"comment": {server_err: "#sverr_comment", maxlength: 255},
			"critic_member": {server_err: "#sverr_critic_member", maxlength: 60},
			"criticism_date[year]": {server_err: "#sverr_criticism_date"}
		}
	});
	$("#comment_search_form").valid();
	// バリデーション設定（出典）
	$("#source_search_form").validate({
		errorPlacement: error_placement,
		groups: {
			distribution_date_grp: "distribution_date[year] distribution_date[month] distribution_date[day] distribution_date[hour] distribution_date[minute] distribution_date[second], distribution_date_comp",
			reporter_job_title_grp: "reporter_job_title_id reporter_job_title"
		},
		rules: {
			"source_id": {server_err: "#sverr_source_id", required: true, digits: true},
			"media_name": {server_err: "#sverr_media_name", maxlength: 60},
			"media_source": {server_err: "#sverr_media_source", maxlength: 60},
			"distribution_date[year]": {server_err: "#sverr_distribution_date"},
			"reporter": {server_err: "#sverr_reporter", maxlength: 60},
			"reporter_job_title_id": {server_err: "#sverr_reporter_job_title", number: true},
			"reporter_job_title": {server_err: "#sverr_reporter_job_title", maxlength: 40}
		}
	});
	$("#source_search_form").valid();
});
