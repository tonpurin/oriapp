$(function() {

  if(document.URL.match("/groups/")){
    // google map初期化
    top_init_gmap();
    // ユーザが選択したアイテムに対するイベント
    selected_item_click();
  };
});