/**
 * list.js
 * @version   : 1.0.0
 * @author    : 仲観派
 * @license   : The MIT License
 * @modified  : 2012-09-20 23:00
 */

function hsv_to_rgb(h, s, v) {
	var r, g, b; // 0..255
	while (h < 0) {h += 360;}
	h = h % 360;
	if (s == 0) {
		v = Math.round(v);
		return {'r': v, 'g': v, 'b': v};
	}
	s = s / 255;
	var i = Math.floor(h / 60) % 6;
	var f = (h / 60) - i;
	var p = v * (1 - s);
	var q = v * (1 - f * s);
	var t = v * (1 - (1 - f) * s);
	switch (i) {
	case 0 :
		r = v;  g = t;  b = p;  break;
	case 1 :
		r = q;  g = v;  b = p;  break;
	case 2 :
		r = p;  g = v;  b = t;  break;
	case 3 :
		r = p;  g = q;  b = v;  break;
	case 4 :
		r = t;  g = p;  b = v;  break;
	case 5 :
		r = v;  g = p;  b = q;  break;
	}
	return '#' + ("0" + Math.round(r).toString(16)).slice(-2)
	           + ("0" + Math.round(g).toString(16)).slice(-2)
			   + ("0" + Math.round(b).toString(16)).slice(-2);
};

function hsb_list(number) {
	var unit_angle = 360 / number;
	var color_list = new Array();
	for(i=number-1; i>=0; i--) {
		rgb_val = hsv_to_rgb(unit_angle * i, 255, 255);
		color_list.push(rgb_val);
	}
	for(j=0; j<number; j++) {
		$("#legend_" + j).css("background", color_list[(number-j-1)]);
	}
	return color_list;
};

$(document).ready(function() {
	// チャートデータ生成
	var data_array = new Array();
	var index_list = ["A","B","C","D","E","F","G","H"]
	var wk_val = $("#graphs_data_" + index_list.shift()).val();
	while(typeof wk_val == "string") {
		data_array.unshift(wk_val.split(","));
		wk_val = $("#graphs_data_" + index_list.shift()).val();
	}
	// チャート描画判定
	if (data_array.length > 0) {
		data_array.unshift($("#graphs_col_names").val().split(","));
		var chartdata = {
			"config": {
				"title": "Line Chart",
				"width": 1242,
				"height": 600,
				"type": "line",
				"lineWidth": 4,
				"colorSet": hsb_list(data_array.length - 1),
				"bgGradient": {
					"direction":"vertical",
					"from":"#687478",
					"to":"#222222"
				}
			},
			"data": data_array
		};
		// チャート描画
		ccchart.init('results_graphs', chartdata);
	}
	// システムIDコンボイベント
	$('#system_id').change(function(){
		params = scr_trans_params('#input_form');
		params['system_id'] = $("#system_id").val();
		$('#function_id').load('function', params);
	});
	// ブラウザIDコンボイベント
	$('#browser_id').change(function(){
		params = scr_trans_params('#input_form');
		params['browser_id'] = $("#browser_id").val();
		$('#browser_version_id').load('browser_version', params);
	});
	// バリデーション設定
	received_date_items = "received_date_from[year] received_date_from[month] received_date_from[day] "
	                    + "received_date_from[hour] received_date_from[minute] received_date_from[second]";
	$("#input_form").validate({
		errorPlacement: error_placement,
		groups: {
			received_date_from: received_date_items
		},
		rules: {
			// 線種別
			"item_1": {server_err: "#sverr_item_1", required: true, hankaku: true},
			"item_2": {server_err: "#sverr_item_2", hankaku: true},
			"item_3": {server_err: "#sverr_item_3", hankaku: true},
			"item_4": {server_err: "#sverr_item_4", hankaku: true},
			"item_5": {server_err: "#sverr_item_5", hankaku: true},
			// 横軸
			"received_date_from[year]": {server_err: "#sverr_received_date_from"},
			"received_date_from[month]": {server_err: "#sverr_received_date_from"},
			"received_date_from[day]": {server_err: "#sverr_received_date_from"},
			"received_date_from[hour]": {server_err: "#sverr_received_date_from"},
			"received_date_from[minute]": {server_err: "#sverr_received_date_from"},
			"received_date_from[second]": {server_err: "#sverr_received_date_from"},
			"time_unit_num": {server_err: "#sverr_time_unit_cond", required: true, number: true},
			// 抽出条件
			"function_trans_no": {server_err: "#sverr_function_trans_no_cond", number: true},
			"login_id": {server_err: "#sverr_login_id", maxlength: 255},
			"client_id": {server_err: "#sverr_client_id", maxlength: 255},
			"accept_language": {server_err: "#sverr_accept_language", hankaku: true},
			"domain_name": {server_err: "#sverr_domain_name_cond", hankaku: true, maxlength: 255},
			"referrer": {server_err: "#sverr_referrer_cond", hankaku: true, maxlength: 255},
			"proxy_host": {server_err: "#sverr_proxy_host_cond", hankaku: true, maxlength: 255},
			"proxy_ip_address": {server_err: "#sverr_proxy_ip_address", hankaku: true},
			"remote_host": {server_err: "#sverr_remote_host_cond", hankaku: true, maxlength: 255},
			"ip_address": {server_err: "#sverr_ip_address", hankaku: true}
		}
	});
	// 初期化処理
	if ($('#system_id').val() != '') {
		$('#system_id').change();
	}
	if ($('#browser_id').val() != '') {
		$('#browser_id').change();
	}
	// バリデーション
	$("#input_form").valid();
});
