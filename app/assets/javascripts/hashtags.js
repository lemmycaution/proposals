$(document).ready(function(){
	$(".hashtag_delete").bind("ajax:success", function(){
		console.log($(this));
		$(this).parents("li").fadeOut(function(){$(this).remove();});
	});
});