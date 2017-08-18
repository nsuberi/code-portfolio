// MainService
angular.module('GalleryService', [])

	// super simple service
	// each function returns a promise object
	.factory('RouteService', function($http) {
		return {
			get : function(origId, destId) {
				return $http.get('/returnRoutes/'+origId+'/'+destId);
			}
		}
	});
