var markers = [];
function initialize() {
  var mapProp = {
    center:new google.maps.LatLng(30.274701, -97.740331),
    zoom: 11,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };
  var map = new google.maps.Map(document.getElementById("gmap"), mapProp);

  $.ajax({
    dataType: 'json',
    url: '/map.json',
    success: function(data) {
      // console.log(JSON.stringify(data));

      var infowindow = new google.maps.InfoWindow();

      var marker, i;
      for (i = 0; i < data.length; i++) {
        marker = new google.maps.Marker({
        position: {lat: data[i].geometry.coordinates[1], lng: data[i].geometry.coordinates[0]},
        title: data[i].properties.name,
        icon: "/assets/pullup_icon-161e51d273f11f61d82e2a252ec5359f020fd16e8302c1604aa71324d3a5f4ac.png", // added .erb extention to access asset_path helper
        map: map,
        });

        google.maps.event.addListener(marker, 'click', (function(marker, i) {
      		return function() {
		        var html = "<strong>" + data[i].properties.name + "</strong> <br/>" +
                      data[i].properties.equipment + "<br/>" + data[i].geometry.coordinates[1] + 
                      ", " + data[i].geometry.coordinates[0];
            infowindow.setContent(html);
		        infowindow.open(map, marker);
		        map.setCenter(new google.maps.LatLng(data[i].geometry.coordinates[1], 
		        																		 data[i].geometry.coordinates[0]));
		        document.getElementById(i).click();
      		} // return function
		    })(marker, i)); // end listener
		    
        markers.push(marker);
      } // for loop
    } // success function
  }); // ajax call
}

google.maps.event.addDomListener(window, 'load', initialize);

function myClick(id) {
  google.maps.event.trigger(markers[id], 'click');
}

$(document).ready(function(){ 
  $('.sidebar-nav').on('click','li', function(){
     $(this).addClass('select').siblings().removeClass('select');
  });
});
