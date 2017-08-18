// MainCtrl
angular.module('DataCtrl', []).controller('DataController', function($scope, $http, ApplicationService, SchoolService, GPService, SupermarketService, GreenSpaceService) {

      $scope.loadApplications = function(files) {
      			// Source: http://mounirmesselmeni.github.io/2012/11/20/reading-csv-file-with-javascript-and-html5-file-api/
            // Check for the various File API support.

            Papa.parse(files[0], {
              complete: function(results){
                console.log("raw: " + results.data);
                console.log("json: " + JSON.stringify(results.data));
                ApplicationService.post(JSON.stringify(results.data));
              },
              header:true
            })

      };

      $scope.loadSchools = function(files) {
      			// Source: http://mounirmesselmeni.github.io/2012/11/20/reading-csv-file-with-javascript-and-html5-file-api/
            // Check for the various File API support.

            Papa.parse(files[0], {
              complete: function(results){
                console.log("raw: " + results.data);
                console.log("json: " + JSON.stringify(results.data));
                SchoolService.post(JSON.stringify(results.data));
              },
              header:true
            })

      };

      $scope.loadSupermarkets = function(files) {
      			// Source: http://mounirmesselmeni.github.io/2012/11/20/reading-csv-file-with-javascript-and-html5-file-api/
            // Check for the various File API support.

            Papa.parse(files[0], {
              complete: function(results){
                console.log("raw: " + results.data);
                console.log("json: " + JSON.stringify(results.data));
                SupermarketService.post(JSON.stringify(results.data));
              },
              header:true
            })

      };

      $scope.loadGreenSpaces = function(files) {
      			// Source: http://mounirmesselmeni.github.io/2012/11/20/reading-csv-file-with-javascript-and-html5-file-api/
            // Check for the various File API support.

            Papa.parse(files[0], {
              complete: function(results){
                console.log("raw: " + results.data);
                console.log("json: " + JSON.stringify(results.data));
                GreenSpaceService.post(JSON.stringify(results.data));
              },
              header:true
            })

      };

      $scope.loadGPs = function(files) {
      			// Source: http://mounirmesselmeni.github.io/2012/11/20/reading-csv-file-with-javascript-and-html5-file-api/
            // Check for the various File API support.

            Papa.parse(files[0], {
              complete: function(results){
                console.log("raw: " + results.data);
                console.log("json: " + JSON.stringify(results.data));
                GPService.post(JSON.stringify(results.data));
              },
              header:true
            })

      };


});
