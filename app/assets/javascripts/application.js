// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

$(document).ready(function(){

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
			var t = $(tmp($.parseJSON(data)));
			
      $(".span4").prepend(t);
    });

});