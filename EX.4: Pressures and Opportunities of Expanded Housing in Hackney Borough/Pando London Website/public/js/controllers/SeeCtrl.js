angular.module('SeeCtrl', []).controller('SeeController', function($scope) {

  $scope.maps = [{
        title: 'Pressure Info',
        url: 'pressureTab.html'
    }, {
        title: 'Opportunity Info',
        url: 'opportunityTab.html'
    },
    {
        title: 'Instructions',
        url: 'instructionsTab.html'
    }];

    $scope.setBackground = {
        'background-image' : './img/background.jpg'
  }

});
