// MainService
angular.module('DataServices', [])

	// super simple service
	// each function returns a promise object
	.factory('ApplicationService', function($http) {
		return {
			get : function() {
				return $http.get('/returnApplications');
			},
      post : function(json){
        return $http.post('/loadOrigins', json)
      }
		}
	})
	.factory('SchoolService', function($http){
		return {
			get : function() {
				return $http.get('/returnSchools');
			},
      post : function(json){
        return $http.post('/loadSchools', json)
      }
		}
	})
	.factory('GPService', function($http){
		return {
			get : function() {
				return $http.get('/returnGPs');
			},
      post : function(json){
        return $http.post('/loadGPs', json)
      }
		}
	})
	.factory('GreenSpaceService', function($http){
		return {
			get : function() {
				return $http.get('/returnGreenSpaces');
			},
      post : function(json){
        return $http.post('/loadGreenSpaces', json)
      }
		}
	})
	.factory('SupermarketService', function($http){
		return {
			get : function() {
				return $http.get('/returnSupermarkets');
			},
      post : function(json){
        return $http.post('/loadSupermarkets', json)
      }
		}
	})
	.factory('DistanceService', function($http){
		return {
			get : function() {
				return $http.get('/returnDistances');
			}
		}
	});
