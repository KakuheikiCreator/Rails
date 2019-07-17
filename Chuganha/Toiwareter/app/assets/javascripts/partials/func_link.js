/**
 * index.js
 * @version   : 1.0.0
 * @author    : 仲観派
 * @license   : The MIT License
 * @modified  : 2013-01-12 09:30
 */
// バリデーション設定
$(document).ready(function() {
	// コンテキストメニューハンドラー
	var event_handler = {
		bindings: {
			'open': function(t) {
				submit_new_window('#'+t.id);
			}
		}
	};
	// コンテキストメニュー
	$("#home_btn").contextMenu('context_menu', event_handler);
	$("#fulltext_search_btn").contextMenu('context_menu', event_handler);
	$("#detail_search_btn").contextMenu('context_menu', event_handler);
	$("#quote_post_btn").contextMenu('context_menu', event_handler);
	$("#logout_btn").contextMenu('context_menu', event_handler);
	$("#member_list_btn").contextMenu('context_menu', event_handler);
	$("#report_list_btn").contextMenu('context_menu', event_handler);
	$("#ng_word_list_btn").contextMenu('context_menu', event_handler);
});