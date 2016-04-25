// functions for Google maps api
// https://syncer.jp/google-maps-javascript-api-matome

// グローバル変数
map = null;
markers = [];
marker_count = 0;

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
    };

    // [canvas]に、[mapOptions]の内容の、地図のインスタンス([map])を作成する
    map = new google.maps.Map( canvas , mapOptions );
  }else{
    console.log('there is a map already');
  };
};

create_marker = function(lat, lng) {

  if (__is_map_exist()){
    // マーカーを作成
    markers[marker_count] = new google.maps.Marker( {
      map: map ,
      position: new google.maps.LatLng(lat, lng),
    });
    marker_count += 1;
  }else{
    console.log('there is no map');
  };
};

move_map_center = function(lat, lng){
  // mapの中心位置を移動
  // すべてのマーカーが表示されるように縮尺を調整

  // マーカーの数で条件分岐
  if (markers.length == 1){

    // 位置情報のオブジェクトを生成
    var latlng = new google.maps.LatLng(lat ,lng) ;
    // mapのメソッドを取得
    map.setCenter(latlng);

  }else{

    // 配置したマーカーの緯度・経度を配列に変換
    var lat = [];
    var lng = [];
    var latlng = null;
    for (var i = 0; i < markers.length; i++) {
      latlng = markers[i].getPosition();
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











