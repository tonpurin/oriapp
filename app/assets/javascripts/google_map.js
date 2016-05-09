// functions for Google maps api
// https://syncer.jp/google-maps-javascript-api-matome

// グローバル変数
map = null;
markers = {};  // user_itemのidとマーカーの対応
markers_id_order = [];  // 入力された順番を保持するための配列

__is_map_exist = function() {

  if (map){
    return true;
  };
  return false;
}

create_map = function() {

  if (!__is_map_exist()){
    // キャンパスの要素を取得する
    var canvas = document.getElementById( 'map-canvas' );

    // 中心の位置座標を指定する
    var latlng = new google.maps.LatLng( 35.792621 , 139.806513 );

    // 地図のオプションを設定する
    var mapOptions = {
      zoom: 15 ,        // ズーム値
      center: latlng ,    // 中心座標 [latlng]

      // ---------- マップのスタイル設定 ---------
      //mapTypeId: google.maps.MapTypeId.ROADMAP,  //マップタイプ
      // mapTypeControlOptions: {
      //   mapTypeIds: [google.maps.MapTypeId.ROADMAP, 'simple']
      // }
    };

    // [canvas]に、[mapOptions]の内容の、地図のインスタンス([map])を作成する
    map = new google.maps.Map( canvas , mapOptions );

    // 以下google mapのスタイル変更
    // http://blog.prostaff1.com/google/1150/
    // https://snazzymaps.com/style/70/unsaturated-browns
    // var samplestyle = [{"featureType":"administrative.land_parcel","elementType":"all","stylers":[{"visibility":"off"}]},{"featureType":"landscape.man_made","elementType":"all","stylers":[{"visibility":"off"}]},{"featureType":"poi","elementType":"labels","stylers":[{"visibility":"off"}]},{"featureType":"road","elementType":"labels","stylers":[{"visibility":"simplified"},{"lightness":20}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"hue":"#f49935"}]},{"featureType":"road.highway","elementType":"labels","stylers":[{"visibility":"simplified"}]},{"featureType":"road.arterial","elementType":"geometry","stylers":[{"hue":"#fad959"}]},{"featureType":"road.arterial","elementType":"labels","stylers":[{"visibility":"off"}]},{"featureType":"road.local","elementType":"geometry","stylers":[{"visibility":"simplified"}]},{"featureType":"road.local","elementType":"labels","stylers":[{"visibility":"simplified"}]},{"featureType":"transit","elementType":"all","stylers":[{"visibility":"off"}]},{"featureType":"water","elementType":"all","stylers":[{"hue":"#a1cdfc"},{"saturation":30},{"lightness":49}]}];

    // var samplestyleOptions = {
    //   name: "シンプル"
    // };

    // var sampleMapType = new google.maps.StyledMapType(samplestyle, samplestyleOptions);
    // map.mapTypes.set('simple', sampleMapType);
    // map.setMapTypeId('simple');

  }else{
    console.log('there is a map already');
  };
};

create_marker = function(lat, lng, uitem_id) {

  if (__is_map_exist()){

    markers[uitem_id] = new google.maps.Marker( {
      map: map ,
      position: new google.maps.LatLng(lat, lng)
    });

    markers_id_order.push(uitem_id);

  }else{
    console.log('there is no map');
  };
};

create_img_marker = function (lat, lng, uitem_id, imge_index) {

  if (__is_map_exist()){

    if (imge_index == 1) {
      markers[uitem_id] = new google.maps.Marker( {
        map: map ,
        position: new google.maps.LatLng(lat, lng),
        icon: new google.maps.MarkerImage(
          "/assets/first-marker.png",  // url
          new google.maps.Size(100,100) // size
        )
      });
      markers_id_order.push(uitem_id);

    }else if (imge_index == 2) {
      markers[uitem_id] = new google.maps.Marker( {
        map: map ,
        position: new google.maps.LatLng(lat, lng),
        icon: new google.maps.MarkerImage(
          "/assets/second-marker.png",  // url
          new google.maps.Size(100,100) // size
        )
      });
      markers_id_order.push(uitem_id);

    }else if (imge_index == 3){
      markers[uitem_id] = new google.maps.Marker( {
        map: map ,
        position: new google.maps.LatLng(lat, lng),
        icon: new google.maps.MarkerImage(
          "/assets/third-marker.png",  // url
          new google.maps.Size(100,100) // size
        )
      });
      markers_id_order.push(uitem_id);

    }else {
      create_marker(lat, lng, uitem_id);
    }

  }else{
    console.log('there is no map');
  };
};

move_map_center = function(lat, lng){
  // mapの中心位置を移動
  // すべてのマーカーが表示されるように縮尺を調整

  // マーカーの数で条件分岐
  if (markers_id_order.length == 1){

    // 位置情報のオブジェクトを生成
    var latlng = new google.maps.LatLng(lat ,lng) ;
    // mapのメソッドを取得
    map.setCenter(latlng);

  }else{

    // 配置したマーカーの緯度・経度を配列に変換
    var lat = [];
    var lng = [];
    var latlng = null;
    for (var i = 0; i < markers_id_order.length; i++) {
      latlng = markers[markers_id_order[i]].getPosition();
      lat[i] = latlng.lat();
      lng[i] = latlng.lng();
    }
    // 最小・最大を算出
    var lat_min = Math.min.apply(null, lat);
    var lng_min = Math.min.apply(null, lng);
    var lat_max = Math.max.apply(null, lat);
    var lng_max = Math.max.apply(null, lng);
    // 南西と北東の座標を作成
    var sw = new google.maps.LatLng(lat_min, lng_min);
    var ne = new google.maps.LatLng(lat_max, lng_max);
    // 地図の中心・縮尺調整
    var latlngBounds = new google.maps.LatLngBounds(sw, ne);
    map.fitBounds(latlngBounds);
  };
};

// top画面におけるgoogle mapの初期化
top_init_gmap = function(){

  // 地図作成
  create_map();
  // 選択中のアイテムの数だけマーカー作成
  var marker_num = gon.user_items_info[0].length
  if (marker_num > 0) {
    for (var i = 0; i < marker_num - 1; i++) {
      var latlng = gon.user_items_info[1][i];
      var user_item_id = gon.user_items_info[2][i];
      create_marker(latlng[0], latlng[1], user_item_id);
    }
    // 最後のマーカーを作成・同時に地図を移動
    var last_marker_latlng = gon.user_items_info[1][marker_num - 1];
    var last_marker_user_item_id = gon.user_items_info[2][marker_num - 1];
    create_marker(last_marker_latlng[0], last_marker_latlng[1], last_marker_user_item_id);
    move_map_center(last_marker_latlng[0], last_marker_latlng[1]);
  };
};

// owner画面におけるgoogle mapの初期化
owner_init_gmap = function(){

  // 地図を作成
  create_map();

  // 選択中のアイテムの数だけマーカー作成
  // 得票数に応じてマーカーのデザインを変更
  var marker_num = gon.user_items_info[0].length;
  var current_vote_max = 100000;
  var maker_img_index = 0;

  if (marker_num > 0) {
    for (var i = 0; i < marker_num - 1; i++) {
      var latlng = gon.user_items_info[1][i];
      var user_item_id = gon.user_items_info[2][i];
      var vote_c = gon.user_items_info[3][i];

      // 得票数のチェック→マーカーのデザインを変更
      if (current_vote_max > vote_c){
        maker_img_index += 1;
        current_vote_max = vote_c;
      }
      create_img_marker(latlng[0], latlng[1], user_item_id, maker_img_index);
    }

    // 最後のマーカーを作成・同時に地図を移動
    var last_marker_latlng = gon.user_items_info[1][marker_num - 1];
    var last_marker_user_item_id = gon.user_items_info[2][marker_num - 1];
    var last_marker_vote_c = gon.user_items_info[3][marker_num - 1];
    create_img_marker(last_marker_latlng[0], last_marker_latlng[1], last_marker_user_item_id, maker_img_index);
    move_map_center(last_marker_latlng[0], last_marker_latlng[1]);
  };
};




