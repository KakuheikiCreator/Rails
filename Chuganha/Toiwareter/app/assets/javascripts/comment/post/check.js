/**
 * check.js
 *
 * @version   : 1.0.0
 * @author    : 仲観派
 * @license   : The MIT License
 * @modified  : 2013-02-01 03:08
 */
//= require jquery.autosize-min
// コメント通報
function return_to_quote() {
	$("#return_form").submit();
	return false;
}

$(document).ready(function() {
	$("textarea").autosize();
});
