// Pusherからの通知を受け取ってイベント発生
// 参照 : http://www.workabroad.jp/posts/2127
// API : https://dashboard.pusher.com/apps/206134/getting_started

$(function() {

  Pusher.logToConsole = true;

  var pusher = new Pusher('78bac7774c6980c3d890', {
      encrypted: true
  });

  // ユーザのIDを使ってチャネルをつなぐ
  // モーダルのアカウント情報からIDを取得
  var user_id = $('.account-id').text().substr(9);
  // チャネル設定
  var channel = pusher.subscribe("group_member_" + user_id);
  channel.bind('notification', function(data) {
    console.log(data.sender);
    console.log(data.group_name);
  });
});