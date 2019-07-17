/**
 * _left_link.js
 *
 * @version   : 1.0.0
 * @author    : 仲観派
 * @license   : The MIT License
 * @modified  : 2012-12-13 06:30
 */
$(document).ready(function() {
	// コンテキストメニューハンドラー
	var event_handler = {
		bindings: {
			'open': function(t) {
				submit_new_window('#'+t.id, '_blank');
			}
		}
	};
	// コンテキストメニュー
	$("#regist_btn").contextMenu('context_menu', event_handler);
	$("#front_btn").contextMenu('context_menu', event_handler);
	$("#login_btn").contextMenu('context_menu', event_handler);
	$("#usage_notice_btn").contextMenu('context_menu', event_handler);
	$("#agreement_btn").contextMenu('context_menu', event_handler);
	$("#privacy_policy_btn").contextMenu('context_menu', event_handler);
	$("#member_list_btn").contextMenu('context_menu', event_handler);
});
