// トップページのイベント周り
// window.onloadは一つのファイルでしか使えない
// → 定義が上書きされる
window.onload = function()
{
  // -------- メソッド -----------------
  // 正面画像のitem_idを取得，2つのボタンのリクエストに反映
  set_current_item_id = function(){

    // 正面itemのidを取得
    gon.current_item_id = parseInt($('.slick-current a img').data("id"));

    // createのリクエスト
    $('.iine_item_id').val(gon.current_item_id);

    // destroyのリクエスト
    var destroy_item_id = $.inArray(gon.current_item_id, gon.voted_items_info[0]);
    if (destroy_item_id >= 0){
      // destroyはユーザ✕アイテムIDが必要
      var destroy_user_item_id = gon.voted_items_info[2][destroy_item_id];
      $('.yokunaine_item_id').attr('href', '/top/'+destroy_user_item_id);
    };
  };
  // -------------------------------------------

  if((!document.URL.match("/users/")) && (!document.URL.match("/groups/")) && (!document.URL.match("/owners/"))){

    // google map初期化
    top_init_gmap();

    $(".display-slide-button").on("click", function(){
      $(".display-items").slideToggle(200);;
    });
    $(".display-items").show();

    // スライド初期化
    $('.pattern4').slick({
      centerMode: true,
      centerPadding: '160px'
    });

    // 画像をスライドさせたら...
    $('.slick-prev, .slick-next').on('click', function() {

      // 真ん中に表示されているアイテムのIDを取得
      set_current_item_id();
      // いいね or よくないねを判断
      toggle_iine_yokunaine();
      // マーカーの代理を作成
      create_marker_agent(gon.items[gon.current_item_id]["item_lat"], gon.items[gon.current_item_id]["item_lng"]);
    });

    // slick.min.jsの一部を無理やり上書き
    // prev, nextの子要素に画像を追加
    var img_element = '<img src="/assets/left-arrow.png" class="left-arrow">';
    $('.slick-prev').text("");
    $('.slick-prev').append(img_element);
    var img_element = '<img src="/assets/right-arrow.png" class="right-arrow">';
    $('.slick-next').text("");
    $('.slick-next').append(img_element);

    // 正面画像のid取得，formに埋め込む
    set_current_item_id();

    // Menuにリンク・イベントを設定
    // ドロップダウンメニューに対してリンクがうまく貼れない...
    // htmlに隠し要素で埋め込んで無理やりクリック
    $('.menu-row1').on('click', function(){
      $('.menu-event1 a').trigger("click");
    });
    $('.menu-row2').on('click', function(){
      $('.menu-event2 a').trigger("click");
    });
    $('.menu-row3').on('click', function(){
      $('.menu-event3 a').trigger("click");
    });$
    ('.menu-row4').on('click', function(){
      $('.menu-event4 a').trigger("click");
    });

    // 初期の正面画像のいいね or よくないねを考慮
    toggle_iine_yokunaine();

    // マーカーの代理を作成
    create_marker_agent(gon.items[gon.current_item_id]["item_lat"], gon.items[gon.current_item_id]["item_lng"]);

    // ユーザが選択したアイテムに対するイベント
    selected_item_click();
  }
};