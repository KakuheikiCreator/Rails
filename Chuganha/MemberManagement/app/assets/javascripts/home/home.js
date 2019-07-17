/**
 * home.js
 *
 * @version   : 1.0.0
 * @author    : 仲観派
 * @license   : The MIT License
 * @modified  : 2012-12-11 15:20
 */
$(document).ready(function() {
	// アコーディオン
    $("#accordion_head").click(function() {
        $(this).next().slideToggle();
    }).next().hide();
});
