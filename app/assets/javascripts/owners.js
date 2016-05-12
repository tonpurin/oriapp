$(function() {

  // google map初期化
  if(document.URL.match("/owners/")){
    owner_init_gmap();

    $(".display-slide-button").on("click", function(){
      $(".display-hotels").slideToggle(200);;
    });

    $(".radius-up").click(function() {
      var radius_value = parseInt($('.radius-value').text());
      if (radius_value < 5) {
        radius_value += 1;
        $('.radius-value').text(radius_value);
      };
    });

    $(".radius-down").click(function() {
      var radius_value = parseInt($('.radius-value').text());
      if (radius_value > 0) {
        radius_value -= 1;
        $('.radius-value').text(radius_value);
      };
    });
  }
});