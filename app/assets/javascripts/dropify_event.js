$( function() {

  // /users/edit or /groups/newに遷移したら実行される
  // 参考 : http://tokidoki-web.com/2013/02/%E3%80%8Ejquery%E3%81%A7%E7%89%B9%E5%AE%9A%E3%81%AEurl%E3%81%8C%E4%B8%80%E8%87%B4%E3%81%97%E3%81%9F%E3%82%89%E5%87%A6%E7%90%86%E3%81%97%E3%81%A6%E3%82%84%E3%82%93%E3%82%88%E3%80%8F/
  if(document.URL.match("/users/edit")) {
        $('.dropify').dropify();
    }
    if(document.URL.match("/groups/new")) {
        $('.dropify').dropify();
    }

});