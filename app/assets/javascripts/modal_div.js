$(function() {

  $('a[rel*=leanModal]').leanModal({
    top: 50,                     // モーダルウィンドウの縦位置を指定
    overlay : 0.8,               // 背面の透明度
    closeButton: ".modal_close"  // 閉じるボタンのCSS classを指定
  });

  $('.members-slide-button').on('click', function (){
    // 押したpタグのvalueを取得
    var user_group_no = $(this).attr("value");
    // 対応するdivを表示 or 非表示
    // http://kachibito.net/snippets/open-slide-panel
    $('.modal-bottom-' + user_group_no).slideToggle(200);
  });

});