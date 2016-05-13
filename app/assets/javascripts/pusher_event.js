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

  // グループ招待に関する通知時の処理
  channel.bind('notification', function(data) {

    var owner_name = data.sender;
    var group_name = data.group_name;
    var user_group_id = data.user_group_id;

    // モーダルの中の承認画面を作成
    $('.owner-name').text(owner_name);
    $('.group-name').text(group_name);
    $('.consent-button').attr('href', '/groups/consent/' + user_group_id);
    $('.object-button').attr('href', '/groups/object/' + user_group_id);

    // 通知ボタンを表示
    $('.right-notification').show();

  });


});
