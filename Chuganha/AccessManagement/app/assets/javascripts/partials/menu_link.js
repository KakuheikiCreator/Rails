/**
 * index.js
 * @version   : 1.0.0
 * @author    : 仲観派
 * @license   : The MIT License
 * @modified  : 2013-05-05 21:00
 */
// レスポンス時間
var diff_time = 0;
// サーバーとの差分時間
function init_difference(){
    diff_time = new Date().getTime() - new Date($("#server_time").val()).getTime();
}
// 時計表示
function clocknow(){
	// 日時情報を取得
    var weeks = new Array("Sun","Mon","Thu","Wed","Thr","Fri","Sat");
    var svr_time = new Date(new Date().getTime() - diff_time);
    var year = svr_time.getFullYear();
    var month = svr_time.getMonth() + 1;
    var day = svr_time.getDate();
    var week = weeks[svr_time.getDay()];
    var hour = svr_time.getHours();
    var min = svr_time.getMinutes();
    var sec = svr_time.getSeconds() + 1;
    // 月、日、時、分、秒が一桁のとき、頭に0を付与
    if (month < 10) { month = "0" + month; }
    if (day < 10) { day = "0" + day; }
    if (hour < 10) { hour = "0" + hour; }
    if (min < 10) { min = "0" + min; }
    if (sec < 10) { sec = "0" + sec; }
    // HTML内に日付・日時を挿入
    $("#server_time_clock").find("#date").html(year + "/" + month + "/" + day + " (" + week + ")");
    $("#server_time_clock").find("#time").html(hour + ":" + min + ":" + sec);
}
// バリデーション設定
$(document).ready(function() {
	// サーバーとのギャップ時間初期化
	init_difference();
	// １秒間隔で繰り返し
	setInterval('clocknow()', 1000);
});