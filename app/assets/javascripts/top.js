// トップページのイベント周り
window.onload = function()
{
  // map表示
  create_map();

  // スライド
  $('.pattern4').slick({

    centerMode: true,
    centerPadding: '160px'

  });

  // slick.min.jsの一部を無理やり上書き
  // prev, nextの子要素に画像を追加
  var img_element = '<img src="assets/left-arrow.png" class="left-arrow">';
  $('.slick-prev').text("");
  $('.slick-prev').append(img_element);
  var img_element = '<img src="assets/right-arrow.png" class="right-arrow">';
  $('.slick-next').text("");
  $('.slick-next').append(img_element);

  // 追加ボタンを押したら...
  $('.iine-button button').on('click', function(){

    // geocode取得
    var lat = $('.slick-current a img').data("lat");
    var lng = $('.slick-current a img').data("lng");
    // markerを作成
    create_marker(lat, lng);
    // 地図を移動
    move_map_center(lat, lng);

  });
};