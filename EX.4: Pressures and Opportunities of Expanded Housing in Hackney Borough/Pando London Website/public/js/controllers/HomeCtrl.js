angular.module('HomeCtrl', []).controller('HomeController', function($scope) {

  $scope.tabs = [{
        title: 'Pressure Info',
        url: 'pressureTab.html'
    }, {
        title: 'Opportunity Info',
        url: 'opportunityTab.html'
    }];

  $scope.currentTab = 'pressureTab.html';

  $scope.onClickTab = function (tab) {
      $scope.currentTab = tab.url;
  }

  $scope.isActiveTab = function(tabUrl) {
      return tabUrl == $scope.currentTab;
  }

});
