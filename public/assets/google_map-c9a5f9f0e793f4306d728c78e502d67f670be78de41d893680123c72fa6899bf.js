map=null,markers={},markers_id_order=[],current_chenge_marker_id=void 0,__is_map_exist=function(){return!!map},create_map=function(){if(__is_map_exist())console.log("there is a map already");else{var e=document.getElementById("map-canvas"),r=new google.maps.LatLng(35.792621,139.806513),a={zoom:15,center:r};map=new google.maps.Map(e,a)}},create_marker=function(e,r,a){__is_map_exist()?(markers[a]=new google.maps.Marker({map:map,position:new google.maps.LatLng(e,r)}),markers_id_order.push(a)):console.log("there is no map")},create_img_marker=function(e,r,a,n){__is_map_exist()?(4>n?markers[a]=new google.maps.Marker({map:map,position:new google.maps.LatLng(e,r),icon:new google.maps.MarkerImage("/assets/marker"+n+".png",new google.maps.Size(100,100))}):create_marker(e,r,a),markers_id_order.push(a)):console.log("there is no map")},chenge_marker_design=function(e){__is_map_exist()?(void 0!=current_chenge_marker_id&&void 0!=markers[current_chenge_marker_id]&&markers[current_chenge_marker_id].setOptions({icon:""}),markers[e].setOptions({icon:new google.maps.MarkerImage("/assets/click-marker.png",new google.maps.Size(100,100))}),current_chenge_marker_id=e):console.log("there is no map")},move_map_center=function(e,r){if(1==markers_id_order.length){var a=new google.maps.LatLng(e,r);map.setCenter(a)}else{for(var e=[],r=[],a=null,n=0;n<markers_id_order.length;n++)a=markers[markers_id_order[n]].getPosition(),e[n]=a.lat(),r[n]=a.lng();var o=Math.min.apply(null,e),m=Math.min.apply(null,r),_=Math.max.apply(null,e),s=Math.max.apply(null,r),i=new google.maps.LatLng(o,m),t=new google.maps.LatLng(_,s),g=new google.maps.LatLngBounds(i,t);map.fitBounds(g)}},top_init_gmap=function(){create_map();var e=gon.user_items_info[0].length;if(e>0){for(var r=0;e-1>r;r++){var a=gon.user_items_info[1][r],n=gon.user_items_info[2][r];create_marker(a[0],a[1],n)}var o=gon.user_items_info[1][e-1],m=gon.user_items_info[2][e-1];create_marker(o[0],o[1],m),move_map_center(o[0],o[1])}},owner_init_gmap=function(){create_map(),alert("avatar");var e=gon.user_items_info[0].length,r=1e5,a=0;if(e>0){for(var n=0;e-1>n;n++){var o=gon.user_items_info[1][n],m=gon.user_items_info[2][n],_=gon.user_items_info[3][n];r>_&&(a+=1,r=_),create_img_marker(o[0],o[1],m,a)}var s=gon.user_items_info[1][e-1],i=gon.user_items_info[2][e-1],t=gon.user_items_info[3][e-1];r>t&&(a+=1),create_img_marker(s[0],s[1],i,a),move_map_center(s[0],s[1])}};