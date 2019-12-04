# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


@initMap = ->
  center = 
    lat: 0
    lng: 0

  map = new (google.maps.Map) $('#map')[0],
    zoom: 2
    center: center

  infowindow = new (google.maps.InfoWindow) #close automatically windows markers already opened 

  $.getJSON '/activities.json', (jsonData) ->
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