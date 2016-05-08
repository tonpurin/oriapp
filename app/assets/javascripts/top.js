// トップページのイベント周り
// window.onloadは一つのファイルでしか使えない
// → 定義が上書きされる
window.onload = function()
{
  // -------- メソッド -----------------
  // 正面画像のitem_idを取得，form_forに埋め込む
  var set_current_item_id = function(){
    gon.current_item_id = parseInt($('.slick-current a img').data("id"));
    $('.form_item_id').val(gon.current_item_id)
  };


  // google map初期化
  init_gmap();

  // スライド初期化
  $('.pattern4').slick({
    centerMode: true,
    centerPadding: '160px'
  });

  // 画像をスライドさせたら...
  $('.slick-prev, .slick-next').on('click', function() {
    // 真ん中に表示されているアイテムのIDを取得
    set_current_item_id();
    // ユーザに選択されたアイテムか否かを判断してボタンをトグル
    // $.inArray(要素, 配列)：要素が配列に存在すればそのインデックスを返す，なければ-1
    if ($.inArray(gon.current_item_id, gon.user_items_ids) >= 0){
      $('.iine-button').hide();
      $('.yokunaine-button').show();
    }else {
      $('.iine-button').show();
      $('.yokunaine-button').hide();
    };
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
  });
};