$(document).ready(function(){
	$(".hashtag_delete").bind("ajax:success", function(){
		$(this).parents("div.well").fadeOut(function(){$(this).remove();});
	});
});