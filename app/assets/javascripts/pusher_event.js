// Pusherからの通知を受け取ってイベント発生
// 参照 : http://www.workabroad.jp/posts/2127
// API : https://dashboard.pusher.com/apps/206134/getting_started

$(function() {
  Pusher.logToConsole = true;
  var pusher = new Pusher('78bac7774c6980c3d890', {
      encrypted: true
  });
  var channel = pusher.subscribe('general_channel');
  channel.bind('notification', function(data) {
    alert(data.message);
  });
});