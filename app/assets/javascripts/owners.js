$(function() {

  if(document.URL.match("/owners/")){

    // 正面のホテルから情報を抽出してホームに埋め込むメソッド
    set_current_item_info = function(){

      // 抽出
      var item_name = $('.slick-current .hotel-name-address .hotel-name').text();
      var item_address = $('.slick-current .hotel-name-address .hotel-address').text();
      var item_url = $('.slick-current .hotel-img a').attr('href');
      var image_url = $('.slick-current .hotel-img img').attr('src');
      var item_id = $('.slick-current .hotel-img img').data('id');
      var item_lat = $('.slick-current .hotel-img img').data('lat');
      var item_lng = $('.slick-current .hotel-img img').data('lng');

      // 埋め込み
      $('.iine_item_id').val(item_id);
      $('.iine_item_name').val(item_name);
      $('.iine_item_address').val(item_address);
      $('.iine_item_url').val(item_url);
      $('.iine_image_url').val(image_url);
      $('.iine_item_lat').val(item_lat);
      $('.iine_item_lng').val(item_lng);

      // destroyのリクエスト
      var destroy_item_id = $.inArray(item_id, gon.voted_items_info[0]);
      if (destroy_item_id >= 0){
        // destroyはユーザ✕アイテムIDが必要
        var destroy_group_item_id = gon.voted_items_info[2][destroy_item_id];
        $('.yokunaine_item_id').attr('href', '/owners/'+destroy_group_item_id);
      };
      gon.current_item_id = item_id;

      return [item_lat, item_lng];

    };

    // google map初期化
    owner_init_gmap();

    // ユーザが選択したアイテムに対するイベント
    selected_item_click();

    $(".display-slide-button").on("click", function(){
      $(".display-hotels").slideToggle(200);;
    });

    // 検索モーダルの中の処理
    $(".radius-up").click(function() {
      var radius_value = parseFloat($('.radius-value').text());
      if (radius_value < 5.0) {
        radius_value += 0.5;
        $('.radius-value').text(radius_value);
      };
    });
    $(".radius-down").click(function() {
      var radius_value = parseFloat($('.radius-value').text());
      if (radius_value > 0.5) {
        radius_value -= 0.5;
        $('.radius-value').text(radius_value);
      };
    });

  }

});