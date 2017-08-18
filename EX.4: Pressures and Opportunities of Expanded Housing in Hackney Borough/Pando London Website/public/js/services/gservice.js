angular.module('gservice', [])
    .factory('gservice', function($rootScope,$http){

      // Initialize Variables
      // -------------------------------------------------------------
      // Service our factory will return
      var googleMapService = {};

      googleMapService.refresh = function(latitude, longitude, points, pointType){

        if (!googleMapService.map){
            // Create a new map and place in the index.html page
            var map = new google.maps.Map(document.getElementById('map'), {
                zoom: 12,
                center: {lat: latitude, lng: longitude},
                styles: darkMap
            });
            googleMapService.map = map;
        }

        var colorMarker = {
          Application: "purple",
          School: "red",
          Supermarket: "brown",
          GreenSpace: "green",
          GP: "blue"
        }

        var opacityMarker = function(numUnits, maxUnits){
          return numUnits/maxUnits;
        }

        console.log(colorMarker[pointType])
        // Loop through each location in the array and place a marker
        points.forEach(function(point,i){

          console.log("New marker: " + JSON.stringify(point));

           var marker = new google.maps.Marker({
               position: new google.maps.LatLng(point.lat, point.lon),
               map: googleMapService.map,
               title: "Big Map",
               icon: {
                  path: google.maps.SymbolPath.CIRCLE,
                  scale: 10,
                  strokeColor: colorMarker[pointType],
                  strokeOpacity: opacityMarker(i,10),
                  fillColor: colorMarker[pointType],
                  fillOpacity: opacityMarker(i,10)
                }
           });

           // For each marker created, add a listener that checks for clicks
           google.maps.event.addListener(marker, 'click', function(e){
               $rootScope.selectApplication(point.id)
           });

         });


      }; // end refresh

      return googleMapService;

    }); // end service
