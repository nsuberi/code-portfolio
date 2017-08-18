// appRoutes.js
angular.module('appRoutes', []).config(['$routeProvider', '$locationProvider', function($routeProvider, $locationProvider) {
	// learn routes!
	$routeProvider

		.when('/', {
			templateUrl: 'views/home.html',
			controller: 'HomeController'
		})
		.when('/gallery', {
			// templateUrl: 'view/subviews/gallery.html',
		// 	controller: 'GalleryController'
			templateUrl: 'views/gallery.html',
			controller: 'GalleryController'
		})
		.when('/insertData', {
			templateUrl: 'views/insertData.html',
			controller: 'DataController'
		})
		.when('/seeit', {
			templateUrl: 'views/seeit.html',
			controller: 'SeeController'
		})
		.when('/about', {
			templateUrl: 'views/about.html',
			controller: null
		})
		.when('/glossary', {
			templateUrl: 'views/glossary.html',
			controller: 'GlossaryController'
		})
		.when('/behind', {
			templateUrl: 'views/behind.html',
			controller: 'BehindController'
		});


	$locationProvider.html5Mode(true);

}]);
