$(function() {

  // google map初期化
  if(document.URL.match("/owners/")){
    owner_init_gmap();

    $(".display-slide-button").on("click", function(){
      $(".display-hotels").slideToggle(200);;
    });

    $(".display-hotels .search-button").on("click", function() {
      alert("aaa");
    });
  }
});