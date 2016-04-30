$(function() {
  $('a[rel*=leanModal]').leanModal({
    top: 50,                     // モーダルウィンドウの縦位置を指定
    overlay : 0.8,               // 背面の透明度
    closeButton: ".modal_close"  // 閉じるボタンのCSS classを指定
  });
});