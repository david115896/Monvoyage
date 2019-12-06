# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


@initMap = ->
  center = 
    lat: 37.566536
    lng: 126.977966

  map = new (google.maps.Map) $('#map')[0],
    zoom: 13
    center: center

  infowindow = new (google.maps.InfoWindow) #close automatically windows markers already opened 

  $.getJSON '/cities/85/activities.json', (jsonData) ->
    $.each jsonData, (key, data) ->
      latLng = new (google.maps.LatLng)(data.lat, data.lng)
      marker = new (google.maps.Marker)
        position: latLng
        map: map
        title: data.name


      google.maps.event.addListener marker, 'click', ->
        infowindow.setOptions
          content: data.content
          maxWidth: 300
        infowindow.open map, marker