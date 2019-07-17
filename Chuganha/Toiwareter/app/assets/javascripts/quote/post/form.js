/**
 * form.js
 *
 * @version   : 1.0.0
 * @author    : 仲観派
 * @license   : The MIT License
 * @modified  : 2013-01-23 23:49
 */
//= require jquery.autosize-min
// 出典フォーム表示
function insertDynamicRows(data, textStatus, XMLHttpRequest) {
	$('[id=dynamic_input_fields]').remove();
	$('#select_source_row').after(data);
}
// 出典選択
function source_selected() {
	$('#ajax_form').find('#source_id').val($(this).val());
	ajax_send('#ajax_form', insertDynamicRows);
}
$(document).ready(function() {
	$('textarea').autosize();
	$('#source_id').on("change", source_selected);
	$(document).on("change", '#source_id', source_selected);
	// バリデーション設定
	$("#quote_form").validate({
		errorPlacement: error_placement,
		groups: {
			job_title_grp: "job_title_id job_title",
			author_job_title_grp: "author_job_title_id author_job_title",
			contributor_job_title_grp: "contributor_job_title_id contributor_job_title",
			reporter_job_title_grp: "reporter_job_title_id reporter_job_title",
			broadcast_date_grp: "broadcast_date[year] broadcast_date[month] broadcast_date[day] broadcast_date[hour] broadcast_date[minute] broadcast_date[second]",
			posted_date_grp: "posted_date[year] posted_date[month] posted_date[day] posted_date[hour] posted_date[minute] posted_date[second]",
			release_date_grp: "release_date[year] release_date[month] release_date[day] release_date[hour] release_date[minute] release_date[second]",
			bbs_name_grp: "bbs_id bbs_detail_name",
			game_console_grp: "game_console_id game_console_dtl_name",
			newspaper_grp: "newspaper_id newspaper_detail",
			edition_grp:  "posted_date_year posted_date[year] posted_date[month] posted_date[day] newspaper_cls",
			sns_name_grp: "sns_id sns_detail_name"
		},
		rules: {
			"quote": {server_err: "#sverr_quote", required: true, maxlength: 400},
			"speaker": {server_err: "#sverr_speaker", required: true, maxlength: 60},
			"job_title_id": {server_err: "#sverr_job_title", number: true},
			"job_title": {server_err: "#sverr_job_title", maxlength: 40},
			"source_id": {server_err: "#sverr_source_id", required: true, number: true},
			"description": {server_err: "#sverr_description", maxlength: 2000},
			"comment": {server_err: "#sverr_comment", required: true, maxlength: 4000},
			// 出所（共通）
			"article_title": {server_err: "#sverr_article_title"},
			"author_job_title_id": {server_err: "#sverr_author_job_title", number: true},
			"contributor_job_title_id": {server_err: "#sverr_contributor_job_title", number: true},
			"reporter_job_title_id": {server_err: "#sverr_reporter_job_title", number: true},
			"broadcast_date[day]": {server_err: "#sverr_broadcast_date"},
			"posted_date[day]": {server_err: "#sverr_posted_date"},
			"release_date[day]": {server_err: "#sverr_release_date"},
			"posted_by": {server_err: "#sverr_posted_by"},
			"sold_by": {server_err: "#sverr_sold_by"},
			"production": {server_err: "#sverr_production"},
			"publisher": {server_err: "#sverr_publisher"},
			"reporter": {server_err: "#sverr_reporter"},
			"quoted_source_url": {server_err: "#sverr_quoted_source_url", maxlength: 255},
			"site_name": {server_err: "#sverr_site_name"},
			"program_name": {server_err: "#sverr_program_name"},
			// 出所（電子掲示板）
			"bbs_id": {server_err: "#sverr_bbs_name", required: true},
			"thread_title": {server_err: "#sverr_thread_title"},
			// 出所（ブログ）
			"blog_name": {server_err: "#sverr_blog_name", required: true},
			"article_title": {server_err: "#sverr_article_title"},
			// 出所（書籍）
			"isbn": {server_err: "#sverr_isbn"},
			"book_title": {server_err: "#sverr_book_title", required: true},
			"author": {server_err: "#sverr_isbn", required: true},
			// 出所（ゲーム）
			"game_console_id": {server_err: "#sverr_game_console", required: true},
			// 出所（雑誌）
			"magazine_name": {server_err: "#sverr_magazine_name", required: true},
			"magazine_cd": {server_err: "#sverr_magazine_cd"},
			// 出所（音楽）
			"music_name": {server_err: "#sverr_music_name", required: true},
			"lyricist": {server_err: "#sverr_lyricist"},
			"composer": {server_err: "#sverr_composer", required: true},
			"jasrac_code": {server_err: "#sverr_jasrac_code"},
			"iswc": {server_err: "#sverr_iswc"},
			// 出所（新聞）
			"newspaper_id": {server_err: "#sverr_newspaper", required: true},
			"newspaper_cls": {server_err: "#sverr_edition", required: true},
			"headline": {server_err: "#sverr_headline", required: true},
			// 出所（その他サイト）
			"page_name": {server_err: "#sverr_page_name"},
			// 出所（その他）
			"media_name": {server_err: "#sverr_media_name", required: true},
			// 出所（ラジオ）
			"radio_station": {server_err: "#sverr_radio_station", required: true},
			// 出所（SNS）
			"sns_id": {server_err: "#sverr_sns_name", required: true},
			// 出所（TV）
			"tv_station": {server_err: "#sverr_tv_station", required: true}
		}
	});
});
