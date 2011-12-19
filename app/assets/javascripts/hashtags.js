$(document).ready(function(){
	$(".hashtag_delete").bind("ajax:success", function(){
		$(this).parents("li").fadeOut(function(){$(this).remove();});
	});
});