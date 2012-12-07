geo_autocomplete
================

A jQuery UI widget to turn a text field into a google maps autosuggest field. 

The original version of this code can be located at [geo-autocomplete on Google Code](http://code.google.com/p/geo-autocomplete/).

In addition to the functionality provided by the original widget, this widget allows for a pinDrop callback, which appends a "drop a pin" option to the autocomplete list.

Usage
-----

    var map = new google.maps.Map(document.getElementById("map_canvas"), {
      center: new google.maps.LatLng(40.7143528,-74.0059731)
    });
    
    $('#search_term').geo_autocomplete({
    	maptype: 'roadmap',
    	map: map,
    	
    	// Callback on pin drop
    	pinDrop: function(event) {
    	  console.log("lat: " + event.latLng.lat());
    	  console.log("lng: " + event.latLng.lng());
      }
    });

Copyright (c) 2010 Bob Hitching, Julia West; Dual licensed under the MIT and GPL licenses.