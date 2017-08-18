angular.module('BehindCtrl', []).controller('BehindController', function($scope) {

  $scope.apis = [{
        endpoint: 'http://128.40.150.34:8857/returnApplications',
        description: 'Returns records for all applications in database in JSON format'
    }, {
        endpoint: 'http://128.40.150.34:8857/returnSupermarkets',
        description: 'Returns records for all applications in database in JSON format'
    },
    {
        endpoint: 'http://128.40.150.34:8857/returnGPs',
        description: 'Returns records for all applications in database in JSON format'
    },
    {
        endpoint: 'http://128.40.150.34:8857/returnSchools',
        description: 'Returns records for all applications in database in JSON format'
    },
    {
        endpoint: 'http://128.40.150.34:8857/returnDistances',
        description: 'Returns records for all applications in database in JSON format'
    },
    {
        endpoint: 'http://128.40.150.34:8857/loadOrigins',
        description: 'Loads a CSV of housing application sites to the database and calculates distances between each application and all services of all types'
    },
    {
        endpoint: 'http://128.40.150.34:8857/loadGPs',
        description: 'Loads a CSV of GP sites to the database and calculates distances between each GP and all application'
    },
    {
        endpoint: 'http://128.40.150.34:8857/loadSupermarkets',
        description: 'Loads a CSV of Supermarket sites to the database and calculates distances between each GP and all application'
    },
    {
        endpoint: 'http://128.40.150.34:8857/loadSchools',
        description: 'Loads a CSV of School sites to the database and calculates distances between each GP and all application'
    }];

    $scope.tools = [
      {
        toolName:"NodeJS",
        imagePath:"./img/web_tools/Nodejs_logo.svg"
      },
      {
        toolName:"AngularJS",
        imagePath:"./img/web_tools/AngularJS.png"
      },
      {
        toolName:"Bookshelf",
        imagePath:"./img/web_tools/bookshelf.svg"
      },
      {
        toolName:"Bootstrap",
        imagePath:"./img/web_tools/Bootstrap_logo.svg"
      },
      {
        toolName:"ChartJS",
        imagePath:"./img/web_tools/chart-js.png"
      },
      {
        toolName:"Express",
        imagePath:"./img/web_tools/express.svg"
      },
      {
        toolName:"Google Maps",
        imagePath:"./img/web_tools/googlemaps-logo.jpg"
      },
      {
        toolName:"Knex",
        imagePath:"./img/web_tools/knex.png"
      },
      {
        toolName:"D3",
        imagePath:"./img/web_tools/Logo_D3.png"
      },
      {
        toolName:"MySQL",
        imagePath:"./img/web_tools/MySQL.png"
      },
      {
        toolName:"Papa Parse",
        imagePath:"./img/web_tools/papaparselogo.png"
      },
      {
        toolName:"Python",
        imagePath:"./img/web_tools/python-logo-inkscape.svg"
      },
      {
        toolName:"Turf",
        imagePath:"./img/web_tools/turf2.png"
      }
    ]

});
