/**
 * default.js
 *
 * @version   : 1.0.0
 * @author    : 仲観派
 * @license   : The MIT License
 * @modified  : 2012-12-13 08:50
 */
//= require jquery-1.8.3.min
//= require jquery.contextmenu.r2.packed
//#############################################################################
// コンテキストメニュー関係
//#############################################################################
// コンテキストメニュースタイル
jQuery.contextMenu.defaults({
	menuStyle : {
		listStyle: 'none',
		padding: '1px',
		margin: '0px',
		backgroundColor: '#fff',
		border: '1px solid #000',
		width: '200px'
	},
	itemStyle: {
		margin: '0px',
		padding: '2px',
		display: 'block',
		cursor: 'default',
		border: '1px solid #000',
		color: '#000',
		backgroundColor: '#fff'
	},
	itemHoverStyle: {
		border: '1px solid #0a246a',
		backgroundColor: '#b6bdd2'
	}
});
//#############################################################################
// デフォルト処理
//#############################################################################
$(document).ready(function() {
	// コンテキストメニューハンドラー
	var event_handler = {
		bindings: {
			'open': function(t) {
				switch (t.id) {
				case "regist_btn":
					window.open("/registration/step_1.html", "_blank");
					break;
				case "front_btn":
					window.open("/index.html", "_blank");
					break;
				case "login_btn":
					window.open("/session/index.html", "_blank");
					break;
				case "usage_notice_btn":
					window.open("/notes_on_use.html", "_blank");
					break;
				case "agreement_btn":
					window.open("/agreement.html", "_blank");
					break;
				case "privacy_policy_btn":
					window.open("/privacy_policy.html", "_blank");
					break;
				}
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
});
