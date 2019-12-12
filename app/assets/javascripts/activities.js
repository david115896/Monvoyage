    

function initMapActivities(activities) {
  var city = gon.city;

  if (activities != null){
    var activities = activities;
  } else {
    var activities = gon.city_activities;
  }


  var location = {lat: city.latitude, lng: city.longitude};
  var map = new google.maps.Map(document.getElementById('map'), {
    center : location, 
    zoom: 12
  });
  var transitLayer = new google.maps.TransitLayer();
  transitLayer.setMap(map);
for(var i = 0; i < activities.length; i++){
      name = Object.values(activities)[i].name,
      point = new google.maps.LatLng(Object.values(activities)[i].latitude,Object.values(activities)[i].longitude);                                     
      contentString = "<h6>"+ name + "</h6>";                    
      marker = new google.maps.Marker({                       
          map: map,
          position: point,
          title: name,
          buborek: contentString 
      }); 
      var infowindow = new google.maps.InfoWindow();
      google.maps.event.addListener(marker, 'click', function(){
          infowindow.setContent(this.buborek); 
          infowindow.open(map,this); 
      });  
      marker.setMap(map);                 
  }
}