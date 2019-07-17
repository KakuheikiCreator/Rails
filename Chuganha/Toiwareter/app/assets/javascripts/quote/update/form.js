/**
 * form.js
 *
 * @version   : 1.0.0
 * @author    : 仲観派
 * @license   : The MIT License
 * @modified  : 2013-01-23 23:49
 */
//= require jquery.autosize-min
// 引用に戻る
function return_to_quote() {
	$("#return_form").submit();
	return false;
}

$(document).ready(function() {
	$('textarea').autosize();
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
			"quote": {server_err: "#sverr_quote", required: true, maxlength: 200},
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
			"broadcast_date[year]": {server_err: "#sverr_broadcast_date"},
			"posted_date[year]": {server_err: "#sverr_posted_date"},
			"release_date[year]": {server_err: "#sverr_release_date"},
			"posted_by": {server_err: "#sverr_posted_by"},
			"sold_by": {server_err: "#sverr_sold_by"},
			"production": {server_err: "#sverr_production"},
			"publisher": {server_err: "#sverr_publisher"},
			"reporter": {server_err: "#sverr_reporter"},
			"quoted_source_url": {server_err: "#sverr_quoted_source_url", maxlength: 255},
			"site_name": {server_err: "#sverr_site_name"},
			"program_name": {server_err: "#sverr_program_name"},
			// 出所（電子掲示板）
			"bbs_id": {server_err: "#sverr_bbs_name"},
			"thread_title": {server_err: "#sverr_thread_title"},
			// 出所（ブログ）
			"blog_name": {server_err: "#sverr_blog_name"},
			"article_title": {server_err: "#sverr_article_title"},
			// 出所（書籍）
			"isbn": {server_err: "#sverr_isbn"},
			"book_title": {server_err: "#sverr_book_title"},
			"author": {server_err: "#sverr_isbn"},
			// 出所（ゲーム）
			"game_console_id": {server_err: "#sverr_game_console"},
			// 出所（雑誌）
			"magazine_name": {server_err: "#sverr_magazine_name"},
			"magazine_cd": {server_err: "#sverr_magazine_cd"},
			// 出所（音楽）
			"music_name": {server_err: "#sverr_music_name"},
			"lyricist": {server_err: "#sverr_lyricist"},
			"composer": {server_err: "#sverr_composer"},
			"jasrac_code": {server_err: "#sverr_jasrac_code"},
			"iswc": {server_err: "#sverr_iswc"},
			// 出所（新聞）
			"newspaper_id": {server_err: "#sverr_newspaper"},
			"newspaper_cls": {server_err: "#sverr_edition"},
			"headline": {server_err: "#sverr_headline"},
			// 出所（その他サイト）
			"page_name": {server_err: "#sverr_page_name"},
			// 出所（その他）
			"media_name": {server_err: "#sverr_media_name"},
			// 出所（ラジオ）
			"radio_station": {server_err: "#sverr_radio_station"},
			// 出所（SNS）
			"sns_id": {server_err: "#sverr_sns_name"},
			// 出所（TV）
			"tv_station": {server_err: "#sverr_tv_station"}
		}
	});
});
