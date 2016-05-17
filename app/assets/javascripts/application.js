// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .
//= require nested_form_fields

toggle_iine_yokunaine = function () {

  // ユーザに選択されたアイテムか否かを判断してボタンをトグル
  // $.inArray(要素, 配列)：要素が配列に存在すればそのインデックスを返す，なければ-1
  if ($.inArray(gon.current_item_id, gon.voted_items_info[0]) >= 0){
    $('.iine-button').hide();
    $('.yokunaine-button').show();
  }else {
    $('.iine-button').show();
    $('.yokunaine-button').hide();
  };
};

current_selected_dom = undefined; // 選択中のアイテム
selected_item_click = function (){

  // ユーザが選択したアイテムに対するイベント
  // クリックした瞬間にボーダーを設定
  // 対象のマーカーを目立たせる
  $('.item-info-middle').click(
    function (){
      if (current_selected_dom != undefined) {
        $(current_selected_dom).css("border", "");
      };
      var item_li = $(this).parent();
      item_li.css("border", "solid 5px #5EABE6");
      current_selected_dom = item_li;

      // マーカーの変更
      var marker_id = parseInt($(item_li).data('id'));
      chenge_current_marker_design(marker_id);
  });
};