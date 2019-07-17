/*!
 * Form Item Create JavaScript Library ver0.1
 *
 * Copyright (C) 2011 引用道 All Rights Reserved.
 *
 * Create Date: 2011/04/12
 */
function mediaSelected(){
	deleteDynamicRows();
	var url = '';
	switch ($("#select_media").val()) {
		case '1':
			url = './txt/newsPaperForm.txt';
			break;
		case '2':
			url = './txt/magazineForm.txt';
			break;
		case '3':
			url = './txt/bookForm.txt';
			break;
		case '4':
			url = './txt/tvForm.txt';
			break;
		case '5':
			url = './txt/radioForm.txt';
			break;
		case '6':
			url = './txt/musicForm.txt';
			break;
		case '7':
			url = './txt/movieForm.txt';
			break;
		case '8':
			url = './txt/gameForm.txt';
			break;
		case '9':
			url = './txt/newsSiteForm.txt';
			break;
		case '10':
			url = './txt/twitterForm.txt';
			break;
		case '11':
			url = './txt/blogForm.txt';
			break;
		case '12':
			url = './txt/snsForm.txt';
			break;
		case '13':
			url = './txt/bbsForm.txt';
			break;
		case '14':
			url = './txt/otherSitesForm.txt';
			break;
		case '15':
			url = './txt/othersForm.txt';
			break;
		default:
			alert("出所分類は選択必須です。");
			break;
	}
	
	if (url.length != 0){
		$.get(url, null, insertDynamicRows, 'text');
	}
}

function deleteDynamicRows(){
	$("[id=dynamic_input_fields]").remove();
	return false;
}

function insertDynamicRows(data, textStatus, XMLHttpRequest){
	$("#select_media_row").after(data);
}

function selectFunction(){
	args = new Array();
	args[0] = "AAA";
	args[1] = "BBB";
	window.showModalDialog('dialog_01.html', args, 'dialogWidth:180px;dialogHeight:160px;center:yes;scroll:no;status:no;help:no;edge:raised;');
}
