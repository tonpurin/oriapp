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
  var user_name = $('.account-id').text().substr(9);

  // チャネル設定
  var channel_member = pusher.subscribe("group_member_" + user_name);
  // グループ招待に関する通知時の処理
  channel_member.bind('notification', function(data) {

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

  // グループIDを使っチャネルをつなぐ

  // チャネル設定
  var channel_owner = pusher.subscribe("group_owner_" + user_name);
  //グループ承認・非承認の通知時の処理
  channel_owner.bind('response', function(data){

    var answer = data.answer;
    var user_group_id = data.user_group_id;
    var group_id = data.group_id;
    if (answer == "consent"){
      $("#member-" + user_group_id + "-name p").css("opacity", "1.0");
    }else{
      $("#member-" + user_group_id + "-name").remove();
    };

  });

});
