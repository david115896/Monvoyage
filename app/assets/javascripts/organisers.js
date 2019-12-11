
function initMap() {
        var city = gon.city;
        var activities = gon.organiser_activities;
       // alert(Object.values(activities)[0].latitude)
         // alert(Object.values(activities)['day1'][1]['latitude'])
       //alert(activities['day0'][0]['latitude'])
        //alert(activities['day0'][1]['latitude'])


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
            //label: labels[labelIndex++ % labels.length],
            //label: label,
            title: title
          });
        }

  
      function renderDirections(result, title_start,title_end ) { 
          //var directionsRenderer = new google.maps.DirectionsRenderer(); 
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


        requestDirections({lat: activities['day0'][0]['latitude'], lng: activities['day0'][0]['longitude']}, {lat: activities['day0'][1]['latitude'], lng: activities['day0'][1]['longitude']}, {name: activities['day0'][0]['name']}, {name: activities['day0'][1]['name']} ); 
        requestDirections({lat: activities['day0'][1]['latitude'], lng: activities['day0'][1]['longitude']}, {lat: activities['day0'][2]['latitude'], lng: activities['day0'][2]['longitude']}, {name: activities['day0'][1]['name']}, {name: activities['day0'][2]['name']}); 

  }

  