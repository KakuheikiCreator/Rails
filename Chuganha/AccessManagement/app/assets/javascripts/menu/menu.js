/**
 * menu.js
 * @version   : 1.0.0
 * @author    : 仲観派
 * @license   : The MIT License
 * @modified  : 2012-02-26 10:00
 */
// バリデーション設定
$(document).ready(function() {
	var event_handler = {
		bindings: {
			'open': function(t) {
				submit_form('#'+t.id, '_blank');
			}
		}
	};
	// コンテキストメニュー
	$("#link_01").contextMenu('context_menu', event_handler);
	$("#link_02").contextMenu('context_menu', event_handler);
	$("#link_03").contextMenu('context_menu', event_handler);
	$("#link_04").contextMenu('context_menu', event_handler);
	$("#link_05").contextMenu('context_menu', event_handler);
	$("#link_06").contextMenu('context_menu', event_handler);
});