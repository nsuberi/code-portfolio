// GalleryCtrl
angular.module('GalleryCtrl', ['pageslide-directive', 'gservice']).controller('GalleryController', function($scope, $http, $q, ApplicationService, SchoolService, GPService, SupermarketService, DistanceService, RouteService, gservice) {


//// HANDLE PAGESLIDE DIRECTIVE

  $scope.checked = false; // This will be binded using the ps-open attribute
  $scope.toggle = function(){
          $scope.checked = !$scope.checked
  }

//// RETRIEVE DATA

  var distanceArray = [];
  var durationArray = [];

  ApplicationService.get().success(function(data){

      $scope.applications = data;
      $scope.mostUnits = 0;
      $scope.numClusters = 0;

      var iMax = data.length;
      var jMax = data.length;
      for (i=0;i<iMax;i++) {

        if(data[i].Total_Residential_Units > $scope.mostUnits) {
          $scope.mostUnits = data[i].Total_Residential_Units;
        }
        if(data[i].Cluster_ID > $scope.numClusters) {
          $scope.numClusters = data[i].Cluster_ID;
        }

         distanceArray[i]=[];
         for (j=0;j<jMax;j++) {
          distanceArray[i][j]=0;
         }
      }

      for (i=0;i<iMax;i++) {
         durationArray[i]=[];
         for (j=0;j<jMax;j++) {
          durationArray[i][j]=0;
         }
      }

      if(data.length > 0){
        console.log("Adding Applications");
        $scope.refreshMap(data, "Application");

        DistanceService.get().success(function(data){

          $scope.distances = data;

          $scope.showClusters();

          angular.forEach($scope.distances, function(item,k){

            // calculate weight for polylines
            var weight = Math.round( 100 * Math.max( $scope.markerArray[item.origId-1].opacity*((1600-item.dist)/1600),  0))/100;
            $scope.distances[k].weight = weight;

            // create distance matrix for clustering
            if(item.destType === "Application"){
                distanceArray[item.origId-1][item.destId-1] = item.dist;
                durationArray[item.origId-1][item.destId-1] = item.dur;
            }

          });

        })
        .then(function(){
          SchoolService.get().success(function(data){
            $scope.schools = data

            if(data.length > 0){
              console.log("Adding schools");
              $scope.refreshMap(data, "School");
            }
          });

          GPService.get().success(function(data){
            $scope.gps = data;

            if(data.length > 0){
              console.log("Adding gps");
              $scope.refreshMap(data, "GP");
            }
          });

          SupermarketService.get().success(function(data){
            $scope.supermarkets = data;

            if(data.length > 0){
              console.log("Adding supermarkets");
              $scope.refreshMap(data, "Supermarket");
            }
          });
        /*  GreenSpaceService.get().success(function(data){
            $scope.greenspaces = data;

            if(data.length > 0){
              console.log("Adding greenspaces");
              $scope.refreshMap(data[0].lat, data[0].lon, data, "GreenSpace");
            }
          });*/
        });
        $scope.distanceMatrix = distanceArray;
        $scope.durationMatrix = durationArray;
      }
    });


///// STORE MAP AND MAP FUNCTIONS

    $scope.googleMap = null;
    $scope.markerArray = [];

    $scope.colorMap = {
      Application: "#ff0000",
      School: "#FFA31A",
      Supermarket: "#00CC00",
      //GreenSpace: "green",
      GP: "#8080ff"
    }

    $scope.markerPaths = {
      School: "./img/Services_svg/School_128X128.svg",
      Supermarket: "./img/Services_svg/Supermarket_128X128.svg",
      GP: "./img/Services_svg/GP_128X128.svg"
    }

    $scope.refreshMap = function(points, pointType){
        if (!$scope.googleMap){
            // Create a new map and place in the index.html page
            var map = new google.maps.Map(document.getElementById('map'), {
                zoom: 13,
                center: {lat: 51.548961, lng: -0.037143},
                styles: lightMap3,
                zoomControlOptions: {
                    position: google.maps.ControlPosition.TOP_LEFT
                },
                scaleControl:true,
                scaleControlOptions:{
                  position: google.maps.ControlPosition.LEFT_TOP
                }
            });
            map.controls[google.maps.ControlPosition.LEFT_BOTTOM].push(document.getElementById('legend'))
            $scope.googleMap = map;
        };

        // Loop through each location in the array and place a marker
        points.forEach(function(point,i){
          // If Application, select icon by num housing
          if(pointType === "Application"){
            // Decide path and scale
            if(point.Total_Residential_Units < 40){
                var iconPath = "./img/Application_svg/HousApp_128X128.svg";
                var iconScale = 8;
            } else if (point.Total_Residential_Units < 200){
              var iconPath = "./img/Application_svg/HousAppx2_128X128.svg";
              var iconScale = 11;
            } else if (point.Total_Residential_Units < 400){
              var iconPath = "./img/Application_svg/HousAppx3_128X128.svg";
              var iconScale = 12;
            } else {
              var iconPath = "./img/Application_svg/HousAppx4_128X128.svg";
              var iconScale = 13;
            }
            // Create icon
            var ptPressure = $scope.opacityMarker(pointType, point)
            var marker = new google.maps.Marker({
                position: new google.maps.LatLng(point.lat, point.lon),
                map: $scope.googleMap,
                icon: new google.maps.MarkerImage(iconPath,
    null, null, null, new google.maps.Size(32,32)) /*{
                   path: iconPath,
                   scale: iconScale,
                   strokeColor: 'white',
                   strokeOpacity: 0,
                   fillColor: $scope.colorMap[pointType],
                   fillOpacity: 1.0
                 }*/,
                 opacity: ptPressure,
                 title: "Total Units: " + point.Total_Residential_Units,
                 iconPath:iconPath,
                 pointType: pointType,
                 pointId: point.id,
            });
            $scope.markerArray.push(marker);
            point.pressure = ptPressure;
          } else {
            // If not an application, then just use the markerPaths array to decide path
            var ptPressure = $scope.opacityMarker(pointType, point)
            var iconPath = $scope.markerPaths[pointType]
            var marker = new google.maps.Marker({
                position: new google.maps.LatLng(point.lat, point.lon),
                map: $scope.googleMap,
                icon: new google.maps.MarkerImage(iconPath,
    null, null, null, new google.maps.Size(28,28)) /*{
                   path: google.maps.SymbolPath.CIRCLE,
                   scale: 10,
                   strokeColor: 'white',
                   strokeOpacity: 0,
                   fillColor: $scope.colorMap[pointType],
                   fillOpacity: 1.0
                 }*/,
                 opacity: ptPressure,
                 title: 'Pressure: '+ptPressure,
                 iconPath: iconPath,
                 pointType: pointType,
                 pointId: point.id
            });
            $scope.markerArray.push(marker);
            point.pressure = ptPressure;
          }

           // For each marker created, add a listener that checks for clicks
           google.maps.event.addListener(marker, 'click', function(e){

              if(pointType === "Application"){
                $scope.selectApplication(point)
              } else {
                $scope.selectDestination(point, pointType);
              }

           });

         });
      }; // end refresh


      $scope.opacityMarker = function(pointType, point){

        if(pointType === "Application"){
          if(point.Total_Residential_Units < 40){
            return .25;
          } else if (point.Total_Residential_Units < 200){
            return .50;
          } else if (point.Total_Residential_Units < 400){
            return .75;
          } else {
            return 1;
          }
        }else{

          // set weight to be sum of 5 highest weights
          var weight = [];

          angular.forEach($scope.distances, function(item){
            if(item.destId == point.id && item.destType === pointType){
              weight.push(item.weight);
            }
          })

          weight.sort(function(a,b){ return b-a; });

          var result = 0;

          for(var i=0; i<5; i++){
            result+=weight[i]*Math.pow(2,-i)
          }

          // console.log("Avg of top 5 weights: " + result/5);
          var avgWeight = Math.round(result*100)/100
          return avgWeight;
          // code from: http://stackoverflow.com/questions/11792158/optimized-javascript-code-to-find-3-largest-element-and-its-indexes-in-array
        }
      }

////// SELECTING APPLICATIONS

    $scope.selectApplication = function(app){

      // Populate item details
      $scope.selectedType = "Application";
      $scope.selectedPoint = app;
      $scope.nearbyPoints = {
        "School":[],
        "GP":[],
        "Supermarket":[]
      };
      // Populate housing stats chart
      $scope.setScatterData([app]);
      $scope.setScatterOptions();

      // Toggle pageslide
      $scope.checked = "true";

      angular.forEach($scope.renderers, function(rend){
        rend.setMap(null);
      })

        var schools = [];
        var supermarkets = [];
        var gps = [];
      //  var greenspaces = [];

        angular.forEach($scope.distances, function(item){

          if(item.origId === app.id && item.destType === "School"){
              schools.push(item);
          }else if(item.origId === app.id && item.destType === "Supermarket"){
              supermarkets.push(item);
          }else if(item.origId === app.id && item.destType === "GP"){
              gps.push(item);
          } /*else if(item.origId === app.id && item.destType === "GreenSpace"){
              greenspaces.push(item);
          }*/

        });

// RETURN DESTINATIONS BY THOSE CLOSEST TO THE APPLICATION
// RETURN DESTINATIONS BY THOSE CLOSEST TO THE APPLICATION
// RETURN DESTINATIONS BY THOSE CLOSEST TO THE APPLICATION

        schools.sort(function(a, b) { return a.dist - b.dist; });
        //console.log("School dists: " + schools);
        supermarkets.sort(function(a, b) { return a.dist - b.dist; });
        //console.log("Supermarket dists: " + supermarkets);
        gps.sort(function(a, b) { return a.dist - b.dist; });
        //console.log("GP dists: " + gps);
        //greenspaces.sort(function(a, b) { return a.dist - b.dist; });
        //console.log("GreenSpace dists: " + greenspaces);

        $scope.schoolChartData = $scope.cumulativeCount(schools);
        $scope.supermarketChartData = $scope.cumulativeCount(supermarkets);
        $scope.gpChartData = $scope.cumulativeCount(gps);
        //$scope.greenspaceChartData = $scope.cumulativeCount(greenspaces);
        $scope.$apply($scope.showChart("D"));

        var lowSet = [schools[0], supermarkets[0], gps[0]];// greenspaces[0]];

        $scope.displayRoutesToDests(lowSet, app.id, ["School", "Supermarket", "GP"]); //, "GreenSpace"]);
    }



////// SELECTING DESTINATIONS

    $scope.selectDestination = function(dest, destType){

      // Populate item details
      $scope.selectedType = destType;
      $scope.selectedPoint = dest;
      $scope.nearbyPoints = {
        "Application":[]
      };
      // Make housing stats chart empty
      $scope.setScatterData([]);
      $scope.setScatterOptions();

      // Toggle pageslide
      $scope.checked = "true";

      angular.forEach($scope.renderers, function(rend){
        rend.setMap(null);
      })

      var applications = [];

      angular.forEach($scope.distances, function(item){
        if(item.destId === dest.id && item.destType == destType){
            applications.push(item);
        }
      });

// RETURN APPLICATIONS BY THE ONES CONTRIBUTING MOST PRESSURE
// RETURN APPLICATIONS BY THE ONES CONTRIBUTING MOST PRESSURE
// RETURN APPLICATIONS BY THE ONES CONTRIBUTING MOST PRESSURE

      applications.sort(function(a, b) { return b.weight - a.weight; });
      $scope.applicationChartData = $scope.cumulativeCount(applications);
      $scope.$apply($scope.showChart("A"));

      var lowSet = applications.slice(0,5);
      $scope.displayRoutesFromApps(lowSet, dest.id, destType);
    }


////// DISPLAYING ROUTES ON DESTINATION SELECT

    $scope.displayRoutesFromApps = function(lowSet, destId, destType){

      // Make arrays available for search
      $scope.destSearch = {
        School: $scope.schools,
        GP: $scope.gps,
      //  GreenSpace: $scope.greenspaces,
        Supermarket: $scope.supermarkets
      }

      $scope.renderers = [];
      for(var i = 0; i < lowSet.length; i++){
        $scope.renderers[i] = new google.maps.DirectionsRenderer({
          polylineOptions: {
            strokeColor: "blue",
            strokeWeight: 5,
            strokeOpacity: lowSet[i].weight
          },
          preserveViewport: true,
          suppressMarkers: true
        });
        $scope.renderers[i].setMap($scope.googleMap);
      }
      $scope.directionsService = new google.maps.DirectionsService();

      var count = 0;
      angular.forEach(lowSet, function(item){

          var routeOrig = new google.maps.LatLng($scope.applications[item.origId-1].lat, $scope.applications[item.origId-1].lon);
          var routeDest = new google.maps.LatLng($scope.destSearch[destType][destId-1].lat,$scope.destSearch[destType][destId-1].lon);

          $scope.directionsService.route({
            origin: routeOrig,
            destination: routeDest,
            travelMode: google.maps.DirectionsTravelMode.WALKING
          }, function(result) {
            // console.log("result: " + count + " :" + JSON.stringify(result))
            renderDirections(result, count);
          });

        })

      function renderDirections(result, index) {
          // console.log("renderer type: " +index);
          $scope.renderers[index].setDirections(result);
          $scope.renderers[index].setMap($scope.googleMap);
          count++;
        }

        // Toggle pageslide
        $scope.checked = "true";

      };

////// DISPLAYING ROUTES ON APPLICATION SELECT

      $scope.displayRoutesToDests = function(lowSet, appId, destTypes){

        // Make arrays available for search
        $scope.destSearch = {
          School: $scope.schools,
          GP: $scope.gps,
        //  GreenSpace: $scope.greenspaces,
          Supermarket: $scope.supermarkets
        }

        $scope.renderers = [];
        for(var i = 0; i < lowSet.length; i++){
          $scope.renderers[i] = new google.maps.DirectionsRenderer({
            polylineOptions: {
              strokeColor: "blue",
              strokeWeight: 5,
              strokeOpacity: lowSet[i].weight
            },
            preserveViewport: true,
            suppressMarkers: true
          });
          $scope.renderers[i].setMap($scope.googleMap);
        }
        $scope.directionsService = new google.maps.DirectionsService();


        var count = 0;
        angular.forEach(lowSet, function(item, i){

          var routeOrig = new google.maps.LatLng($scope.applications[appId-1].lat, $scope.applications[appId-1].lon);
          var routeDest = new google.maps.LatLng($scope.destSearch[destTypes[i]][item.destId-1].lat,$scope.destSearch[destTypes[i]][item.destId-1].lon);

            $scope.directionsService.route({
              origin: routeOrig,
              destination: routeDest,
              travelMode: google.maps.DirectionsTravelMode.WALKING
            }, function(result) {
              // console.log("result: " + count + " :" + result)
              renderDirections(result, count);
            });

          })

          /// SET Z INDEX FOR MARKERS TO BE  HIGHER
          /// SET Z INDEX FOR MARKERS TO BE  HIGHER
          /// SET Z INDEX FOR MARKERS TO BE  HIGHER

          function renderDirections(result, index) {
              // console.log("renderer type: " +index);
              $scope.renderers[index].setDirections(result);
              $scope.renderers[index].setMap($scope.googleMap);

              count++;
            }

            // Toggle pageslide
            $scope.checked = "true";

        };

///// CHART FUNCTIONS

    // aORd = "A", or "D"
    // If "A", show chart for selected application
    // If "D", show chart for selected destination
    $scope.showChart = function(aORd){
      if(aORd === "D"){

        $scope.chartData= [
          $scope.schoolChartData,
          $scope.gpChartData,
          $scope.supermarketChartData
          // $scope.greenspaceChartData
        ];

        $scope.chartSeries = [
          "Schools",
          "GPs",
          "Supermarkets"
//          "Green Spaces"
        ];

        $scope.chartColors = [
          $scope.colorMap["School"],
          $scope.colorMap["GP"],
          $scope.colorMap["Supermarket"]
        ]

      } else if(aORd === "A") {

        $scope.chartData= [
          $scope.applicationChartData
        ];

        $scope.chartSeries = [
          "Applications"
        ];

        $scope.chartColors = [
          $scope.colorMap["Application"]
        ]

      };

        $scope.chartLabels =[
          "0m","400m", "800m", "1200m", "1600m"
        ]

    }

    $scope.cumulativeCount = function(itemArray){
        var cutoffs = [0,400,800,1200,1600];
        var counts = [];
        var nearbyPoints = [];

        for(var i = 0; i < itemArray.length; i++){
          if(counts.length < cutoffs.length){
            if(cutoffs[counts.length] < itemArray[i].dist){
              counts.push(i);
              i--;
            }
            if(nearbyPoints.length == i){
              console.log("Item index: " + i)
              console.log("Pushing item: " + JSON.stringify(itemArray[i]));
              nearbyPoints.push(i)

              // Add to the correct array, allowing for visualizing each
              // resource separately on the applications tab
              if($scope.selectedType === "Application"){
                $scope.nearbyPoints[itemArray[i].destType].push(itemArray[i]);
              } else {
                $scope.nearbyPoints["Application"].push(itemArray[i]);
              }

            }
          }

        }

        // Fill in rest of counts if max distance was less than cutoffs
        while(counts.length < cutoffs.length) counts.push(itemArray.length);

        //console.log("itemArray: " + JSON.stringify(itemArray))
        return counts;
    }

    ////// CLUSTER FUNCTIONS

        $scope.showClusters = function(){

            var clusterPoints = [];
            var detailedItems = [];
            angular.forEach($scope.applications, function(item){
              if(!clusterPoints[item.Cluster_ID]) {
                clusterPoints[item.Cluster_ID] = [];
                detailedItems[item.Cluster_ID] = [];
                clusterPoints[item.Cluster_ID].push(turf.point([item.lon, item.lat]));
                detailedItems[item.Cluster_ID].push(item);
              }else {
                clusterPoints[item.Cluster_ID].push(turf.point([item.lon, item.lat]));
                detailedItems[item.Cluster_ID].push(item);
              }
            })

            for(var i = 1; i < clusterPoints.length; i++){
              if(clusterPoints[i].length>2){
                var featureColl = turf.featurecollection(clusterPoints[i])

                var hull = turf.convex(featureColl)

                var buffer = turf.buffer(hull, .1, "kilometers")

                // Only add cluster if delivering more than 50 units
                var unitsDelivered = 0;
                angular.forEach(detailedItems[i], function(item){
                  unitsDelivered += item.Total_Residential_Units;
                }); // end foreach

                if(unitsDelivered > 40) $scope.googleMap.data.addGeoJson({
                  type: "Feature",
                  geometry:buffer.features[0].geometry,
                  properties: {
                    points: detailedItems[i],
                    isColorful: false
                  }
                });// end if

              } // end if
            } // end for loop

            $scope.googleMap.data.setStyle(function(feature){
              var strokeOpac = 0;
              if(feature.getProperty('isColorful')){
                  strokeOpac = .5;
              }
              return /** @type {google.maps.Data.StyleOptions} */({
                fillColor: '#cc0000',
                fillOpacity: .2,
                strokeColor: '#cc0000',
                strokeOpacity: strokeOpac,
                zIndex: 10,
                visible: true
                });
            });

            $scope.googleMap.data.addListener('click', function(event) {
              // Bring out pageslide
              $scope.$apply($scope.checked = true);
              // Set scatterplot data to show housing cluster
              $scope.setScatterData(event.feature.getProperty('points'));
              $scope.setScatterOptions();
              $scope.clusterStatistics(event.feature.getProperty('points'))

              $scope.selectedType = "Cluster";
              $scope.selectedCluster = event.feature;

              $scope.$apply($scope.clearChartData());


            });

            // Highlight cluster fill when you mouseover it
            $scope.googleMap.data.addListener('mouseover', function(event) {
              event.feature.setProperty('isColorful', true);
            });
              $scope.googleMap.data.addListener('mouseout', function(event) {
                event.feature.setProperty('isColorful', false);
            });
        }

        $scope.setScatterData = function(points) {
            var data = [{
                key: 'All Points',
                values: []
              },
              {
                  key: 'Selected Point(s)',
                  values: []
              }]
            angular.forEach(points, function(point){
              if(point.Housing_Density < 2500){
                data[1].values.push({
                       x: point.Housing_Density
                     , y: point.Proposed_Total_Aff_Per
                          });
              }
            });
            angular.forEach($scope.applications, function(app){
              if(app.Housing_Density < 2500){
                data[0].values.push({
                       x: app.Housing_Density
                     , y: app.Proposed_Total_Aff_Per
                          });
              }

            });
          $scope.$apply($scope.scatterData = data);
        }

        $scope.clusterStatistics = function(points){
          var residentialUnits = 0;
          var affordableUnits = 0;
          var completedUnits = 0;
          var submittedUnits = 0;
          angular.forEach(points, function(point){
            residentialUnits += point.Total_Residential_Units;
            affordableUnits += point.Total_Aff_Units;
            if(point.Permission_Status !== "Submitted"){
              completedUnits += 1;
            }
            submittedUnits += 1;
          })
          $scope.affordableInCluster = affordableUnits;
          $scope.residentialInCluster = residentialUnits;
          $scope.completedInCluster = completedUnits;
          $scope.submittedInCluster = submittedUnits;
          $scope.affordableInClusterPer = Math.round(affordableUnits*100/residentialUnits);
          $scope.completedInClusterPer = Math.round(completedUnits*100/submittedUnits);

        }

        $scope.setScatterOptions = function(){
          $scope.scatterOptions = {
              chart: {
                  type: 'scatterChart',
                  height: 300,
                  width: 340,
                  color: d3.scale.category10().range(),
                  scatter: {
                      onlyCircles: false
                  },
                  showDistX: true,
                  showDistY: true,
                  tooltipContent: function(key) {
                      return '<h3>' + key + '</h3>';
                  },
                  duration: 350,
                  xAxis: {
                      axisLabel: 'Housing Density: Units/ha.',
                      tickFormat: function(d){
                          return d3.format('.00f')(d);
                      }
                  },
                  yAxis: {
                      axisLabel: 'Percent Affordable Housing Units',
                      tickFormat: function(d){
                          return d3.format('.00f')(d);
                      },
                      axisLabelDistance: -5
                  },
                  zoom: {
                      //NOTE: All attributes below are optional
                      enabled: false,
                      scaleExtent: [1, 10],
                      useFixedDomain: false,
                      useNiceScale: false,
                      horizontalOff: false,
                      verticalOff: false,
                      unzoomEventType: 'dblclick.zoom'
                  }
              }
          };
        }

        $scope.clearChartData = function(){
          $scope.selectedPoint = null;
          $scope.nearbyPoints = null;

          $scope.schoolChartData = null;
          $scope.gpChartData = null;
          $scope.supermarketChartData = null;
          $scope.applicationChartData = null;

          $scope.chartData = null;
          $scope.chartSeries = null;
          $scope.chartLabels = null;
        }


////// INTERACTIVITY

        // point = marker that corresponds to moused over text
        // selectedType = type of marker selection that triggered pageslide
        // headerTarget = BOOLEAN, true if we are highlighting the header
        $scope.highlightMarker = function(point, selectedType, headerTarget){
          var offsetService = new google.maps.Point(0,1.4);
          var offsetApplication = new google.maps.Point(0,1.6);
            if(selectedType === "Application"){
                if(headerTarget){
                  // change icon type of selected application
                  angular.forEach($scope.markerArray, function(marker){
                    if(marker.pointId === point.id && marker.pointType === "Application"){
                      marker.setIcon({
                           path: google.maps.SymbolPath.CIRCLE,
                           scale: 10,
                           strokeColor: 'black',
                           strokeOpacity: 1.0,
                           fillColor: "purple",
                           fillOpacity: 1.0,
                           anchor: offsetApplication
                         });// end setIcon
                    } // end inner if
                  }) // end foreach
                } else { // END HIGHLIGHT HOUSING APP IN HEADER
                angular.forEach($scope.markerArray, function(marker){
                  if(marker.pointId === point.destId && marker.pointType === point.destType){
                    marker.setIcon({
                         path: google.maps.SymbolPath.CIRCLE,
                         scale: 10,
                         strokeColor: 'black',
                         strokeOpacity: 1.0,
                         fillColor: $scope.colorMap[point.destType],
                         fillOpacity: 1.0,
                         anchor: offsetService
                       }); // end setIcon
                  } // end inner if
                }) // end foreach // END HIGHLIGHT SERVICE SITES IN BODY
              } // end ifelse for headertarget, applications
            } else if(selectedType === "Cluster") {
                if(headerTarget){
                  // point here = event.feature from the click event on the cluster
                  point.setProperty('isColorful', true);
                }else{
                  // change icon type of selected application
                  angular.forEach($scope.markerArray, function(marker){
                    if(marker.pointId === point.id && marker.pointType === "Application"){
                      marker.setIcon({
                           path: google.maps.SymbolPath.CIRCLE,
                           scale: 10,
                           strokeColor: 'black',
                           strokeOpacity: 1.0,
                           fillColor: "purple",
                           fillOpacity: 1.0,
                           anchor: offsetApplication
                         });// end setIcon
                    } // end inner if
                  }) // end foreach
                }// end header if-else for selected cluster
            }else { // If selected type is not application...
              if(headerTarget){ // HIGHLIGHT SELECTED SERVICE SITES IN HEADER
                angular.forEach($scope.markerArray, function(marker){
                  if(marker.pointId === point.id && marker.pointType === selectedType){
                    marker.setIcon({
                         path: google.maps.SymbolPath.CIRCLE,
                         scale: 10,
                         strokeColor: 'black',
                         strokeOpacity: 1.0,
                         fillColor: $scope.colorMap[selectedType],
                         fillOpacity: 1.0,
                         anchor: offsetService
                       }); // end setIcon
                  } // end inner if
                }) // end foreach
              } else { // Header is not the target
              angular.forEach($scope.markerArray, function(marker){
                if(marker.pointId === point.origId && marker.pointType === "Application"){
                  marker.setIcon({
                       path: google.maps.SymbolPath.CIRCLE,
                       scale: 10,
                       strokeColor: 'black',
                       strokeOpacity: 1.0,
                       fillColor: "purple",
                       fillOpacity: 1.0,
                       anchor: offsetApplication
                     });// end setIcon
                } // end inner if
              }) // end foreach
            }; // end if-else
          } // END HEADER IF ELSE
        };

        $scope.revertOpacity = function(point, selectedType, headerTarget){

          if(selectedType === "Application"){
            if(headerTarget){
              angular.forEach($scope.markerArray, function(marker){
                if(marker.pointId === point.id && marker.pointType === "Application"){
                  marker.setIcon(new google.maps.MarkerImage(marker.iconPath,
      null, null, null, new google.maps.Size(32,32))); // end setIcon
                } // end inner if
              }) // end foreach
            } else {
              angular.forEach($scope.markerArray, function(marker){
                if(marker.pointId === point.destId && marker.pointType === point.destType){
                  marker.setIcon(new google.maps.MarkerImage(marker.iconPath,
      null, null, null, new google.maps.Size(28,28))); // end setIcon
                } // end inner if
              }) // end foreach
            } // end if-else for applications
          } else if (selectedType === "Cluster"){
            if(headerTarget){
              // point = event.feature from the click event on the cluster
              point.setProperty('isColorful', false);
            }else{
              angular.forEach($scope.markerArray, function(marker){
                if(marker.pointId === point.id && marker.pointType === "Application"){
                  marker.setIcon(new google.maps.MarkerImage(marker.iconPath,
      null, null, null, new google.maps.Size(32,32))); // end setIcon
                } // end inner if
              }) // end foreach
            }


          }{ // service selected
            if(headerTarget){
              angular.forEach($scope.markerArray, function(marker){
                if(marker.pointId === point.id && marker.pointType === selectedType){
                  marker.setIcon(new google.maps.MarkerImage(marker.iconPath,
      null, null, null, new google.maps.Size(28,28))); // end setIcon
                } // end inner if
              }) // end foreach
            }
            angular.forEach($scope.markerArray, function(marker){
              if(marker.pointId === point.origId && marker.pointType === "Application"){
                marker.setIcon( new google.maps.MarkerImage(marker.iconPath,
           null, null, null, new google.maps.Size(32,32)));// end setIcon
              }; // end inner if
            }) // end foreach
          }; // end if-else

        };


//// OPERATING TABS

        $scope.tabs = [{
              title: 'Pressure Data',
              url: 'serviceInfoTab.html'
          }, {
              title: 'Site Info',
              url: 'siteInfoTab.html'
          }];

        $scope.currentTab = 'serviceInfoTab.html';

        $scope.onClickTab = function (tab) {
            $scope.currentTab = tab.url;
        }

        $scope.isActiveTab = function(tabUrl) {
            return tabUrl == $scope.currentTab;
        }



    }); // end module


    /*
        $scope.changeClusters = function(eps, min){

          var dataset = $scope.applications

          var optics = new OPTICS();
          // parameters: 2 - neighborhood radius, 2 - number of points in neighborhood to form a cluster
          var clusters = optics.run(dataset, eps, min, true, $scope.distanceMatrix);

          var plot = optics.getReachabilityPlot();
          //console.log(clusters, plot)
          $scope.clusters = clusters;
          $scope.numClusters = clusters.length

        }
        */
