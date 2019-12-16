
function initMapOrganiser(new_activities) {
        var city = gon.city;
        if (new_activities!= null) {
          var activities = JSON.parse(new_activities);
        } else {
          var activities = gon.organiser_activities;
        }

        var directionsService = new google.maps.DirectionsService;
        var map = new google.maps.Map(document.getElementById('map'), {
          zoom: 13,
          center: {lat: city.latitude, lng: city.longitude}
        });

        var icons = {
          start: new google.maps.MarkerImage(
            // URL
            'http://maps.google.com/mapfiles/ms/micons/blue.png',
            // (width,height)
            new google.maps.Size(44, 32),
            // The origin point (x,y)
            new google.maps.Point(0, 0),
            // The anchor point (x,y)
            new google.maps.Point(22, 32)),
          end: new google.maps.MarkerImage(
            // URL
            'http://maps.google.com/mapfiles/ms/micons/green.png',
            // (width,height)
            new google.maps.Size(44, 32),
            // The origin point (x,y)
            new google.maps.Point(0, 0),
            // The anchor point (x,y)
            new google.maps.Point(22, 32))
        };

        function makeMarker( position, icon, title, label ) {
          new google.maps.Marker({
            position: position,
            map: map,
            icon: icon,
            title: title
          });
        }
  
      function renderDirections(result, title_start,title_end ) { 
        var directionsRenderer = new google.maps.DirectionsRenderer({suppressMarkers: true});

        directionsRenderer.setMap(map); 
        directionsRenderer.setDirections(result); 
        var leg = result.routes[ 0 ].legs[ 0 ];
        makeMarker( leg.start_location, icons.start, title_start, "start" );
        makeMarker( leg.end_location, icons.end, title_end, "end" );
        
      }     

      function requestDirections(start, end, title_start,title_end ) { 

        directionsService.route({ 
          origin: start, 
          destination: end, 
          travelMode: 'TRANSIT' //WALKING, TRANSIT, DRIVING
          
        }, function(result) { 
          renderDirections(result, title_start.name, title_end.name); 
        }); 
      }

      function requestDirections2(start, end, title_start,title_end ) { 

        directionsService.route({ 
          origin: start, 
          destination: end, 
          travelMode: 'WALKING' //WALKING, TRANSIT, DRIVING
          
        }, function(result) { 
          renderDirections(result, title_start.name, title_end.name); 
        }); 
      }
    
      for (var i = 0; i < Object.values(activities).length; i++) {
        var activity =  `activity${i}`;
        var activity_next =  `activity${i+1}`;
        if ( activities[activity][3] != "Tokyo" && activities[activity][3] != "Seoul"){
          try {
          requestDirections({lat: activities[activity][0], lng: activities[activity][1]}, {lat: activities[activity_next][0], lng: activities[activity_next][1]}, {name: activities[activity][2]}, {name: activities[activity_next][2]} ); 
          }
          catch(e) {

          }
        } else{
          try {
          requestDirections2({lat: activities[activity][0], lng: activities[activity][1]}, {lat: activities[activity_next][0], lng: activities[activity_next][1]}, {name: activities[activity][2]}, {name: activities[activity_next][2]} ); 
          }
          catch(e) {

          }
        }

      }

}

  