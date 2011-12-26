$(document).ready(function(){

	$(".hashtag .delete").bind("ajax:success", function(){
		$(this).parents("div.well").fadeOut(function(){$(this).remove();});
	});
	
	_.templateSettings = {
		interpolate : /\{\{(.+?)\}\}/g
	};

	// Enable pusher logging - don't include this in production
	Pusher.log = function(message) {
		if (window.console && window.console.log) window.console.log(message);
	};

	// Flash fallback logging - don't include this in production
	WEB_SOCKET_DEBUG = true;

	var pusher = new Pusher('e17d35657dacb66eafa0');
	var channel = pusher.subscribe('tracker');
	channel.bind('new_tweet', function(data) {

		console.log(data);

		var tmp = _.template($("#proposal_tmp").html());
		var t = $(tmp(data.tweet));

		t.addClass('fresh');
		$("#latest_proposals").prepend(t);
		setTimeout(function(){
		$("blockquote#"+data.tweet.id).removeClass('fresh');
		},5000);
	});
	
	var channel2 = pusher.subscribe('updater');
	channel2.bind('update_tweet', function(data) {

		console.log(data);

		var tmp = _.template($("#proposal_tmp_wide").html());
		var t = $(tmp(data.tweet));

		$("blockquote#"+data.tweet.id).replaceWith(t);
		$("blockquote#"+data.tweet.id).addClass('fresh');
		setTimeout(function(){
		$("blockquote#"+data.tweet.id).removeClass('fresh');
		},5000);
	});


});