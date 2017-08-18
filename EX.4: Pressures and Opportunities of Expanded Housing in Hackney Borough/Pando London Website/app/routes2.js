// routes.js
// Models and Collections
var Application = require('./models/ModelsCollections')["Application"];
var Applications = require('./models/ModelsCollections')["Applications"];

var Supermarket = require('./models/ModelsCollections')["Supermarket"];
var Supermarkets = require('./models/ModelsCollections')["Supermarkets"];

var GP = require('./models/ModelsCollections')["GP"];
var GPs = require('./models/ModelsCollections')["GPs"];

var School = require('./models/ModelsCollections')["School"];
var Schools = require('./models/ModelsCollections')["Schools"];

var GreenSpace = require('./models/ModelsCollections')["GreenSpace"];
var GreenSpaces = require('./models/ModelsCollections')["GreenSpaces"];

var Distance = require('./models/ModelsCollections')["Distance"];
var Distances = require('./models/ModelsCollections')["Distances"];

// Handling modules
var async = require('async');
var https = require('https');

module.exports = function(app){

  // Generic CALL ALLS
  app.get('/returnApplications', function (req, res) {
        res.header("Access-Control-Allow-Origin", "*");
        res.header("Access-Control-Allow-Headers", "X-Requested-WithD");

        Applications.forge()
        .fetch()
        .then(function(collection){
            res.json(collection.toJSON());
        })
        .catch(function(err){
          res.status(500).json({error:true, data: {message:err.message}});
        });
      }); // end app.GET

  app.get('/returnSupermarkets', function (req, res) {
        res.header("Access-Control-Allow-Origin", "*");
        res.header("Access-Control-Allow-Headers", "X-Requested-WithD");

        Supermarkets.forge()
        .fetch()
        .then(function(collection){
            res.json(collection.toJSON());
        })
        .catch(function(err){
          res.status(500).json({error:true, data: {message:err.message}});
        });
      }); // end app.GET

  app.get('/returnGPs', function (req, res) {
        res.header("Access-Control-Allow-Origin", "*");
        res.header("Access-Control-Allow-Headers", "X-Requested-WithD");

        GPs.forge()
        .fetch()
        .then(function(collection){
            res.json(collection.toJSON());
        })
        .catch(function(err){
          res.status(500).json({error:true, data: {message:err.message}});
        });
      }); // end app.GET

  app.get('/returnGreenSpaces', function (req, res) {
        res.header("Access-Control-Allow-Origin", "*");
        res.header("Access-Control-Allow-Headers", "X-Requested-WithD");

        GreenSpaces.forge()
        .fetch()
        .then(function(collection){
            res.json(collection.toJSON());
        })
        .catch(function(err){
          res.status(500).json({error:true, data: {message:err.message}});
        });
      }); // end app.GET

  app.get('/returnSchools', function (req, res) {
        res.header("Access-Control-Allow-Origin", "*");
        res.header("Access-Control-Allow-Headers", "X-Requested-WithD");

        Schools.forge()
        .fetch()
        .then(function(collection){
            res.json(collection.toJSON());
        })
        .catch(function(err){
          res.status(500).json({error:true, data: {message:err.message}});
        });
      }); // end app.GET


  app.get('/returnDistances', function (req, res) {
        res.header("Access-Control-Allow-Origin", "*");
        res.header("Access-Control-Allow-Headers", "X-Requested-WithD");

        Distances.forge()
        .fetch()
        .then(function(collection){
            res.json(collection.toJSON());
        })
        .catch(function(err){
          res.status(500).json({error:true, data: {message:err.message}});
        });
      }); // end app.GET

// Loading Origin
app.post('/loadOrigins', function (req, res) {
      // Alows data to be downloaded from the server with security concerns
      res.header("Access-Control-Allow-Origin", "*");
      res.header("Access-Control-Allow-Headers", "X-Requested-WithD");
      // grab JSON from request
      var responseJSON = req.body;
      console.log(responseJSON);

      // for each item in the JSON:
      //// add to application database
      //// call for distance calculation
      async.eachSeries(responseJSON, function(item,eachCallback){
        async.waterfall([

          function(callback){
            // add to applications database
            if(item['lat'] != null && item['lon'] != null && item['cluster'] != null && item['numberApp'] != null){
              Application.forge({
                lat: item['lat'],
                lon: item['lon'],
                cluster: item['cluster'],
                price: item['price']
              })
              .save()
              .then(function(application){
                  // retain result and pass to next step
                  callback(null, application.toJSON());
              })
              .catch(function(err){
                  // pass error to next step
                  callback(null, err.message);
              });
            } else {
              console.log("Didn't run")
              callback(null, false)
            }
          }, // pass application to next step, where destinations are fetched

          // Supermarkets
          function(application, callback){
              if(application){
                // retrieve a list of all schools of all types
                Supermarkets.forge()
                .fetch()
                .then(function(supermarkets){
                    // pass to calculate distances
                    callback(null, application, supermarkets.toJSON());
                })

              } else{
                  callback(null, false, false);
              }
            } // pass application and all supermarkets to calculate distances
            ,
//ok
          function(application, supermarkets, callback){
            if(application){
                console.log("Pre JSON Supermarkets: " + supermarkets);
                console.log("Supermarkets: " + JSON.stringify(supermarkets));
                console.log("Application ID: " + application['id']);
                console.log("Application ID: " + JSON.stringify(application));
                // for each destination, make call to distance

                async.eachSeries(supermarkets, function(supermarket, eachCallback){

                  async.waterfall([
                    function(callback){
                      console.log("Supermarket: " + supermarket)
                      console.log("Supermarket ID: " + supermarket['id']);
                      console.log("Application ID: " + application['id']);

                      host = "maps.googleapis.com";
                      apiKey = "AIzaSyDzF8M6_0H_Gf4POLQ8tw1fG9PL38aWRKQ";
                      endpoint = "/maps/api/distancematrix/json?";
                      path = "origins="+application['lat']+","+application['lon']+"&destinations="+supermarket['lat']+","+supermarket['lon']+"&key=";

                      options = {
                        host: host,
                        path: endpoint+path+apiKey
                      };

                      https.get(options,function(res){

                        var data = "";
                        res.on("data", function(chunk){
                          data += chunk;
                        });
                        res.on("end", function(){
                          var responseObject = JSON.parse(data);
                          console.log(responseObject);
                          var dist = responseObject["rows"][0]["elements"][0]["distance"]["value"];
                          var dur = responseObject["rows"][0]["elements"][0]["duration"]["value"];
                          Distance.forge({
                            origID: application['id'],
                            destID: supermarket['id'],
                            destType: "Supermarket",
                            dist: dist,
                            dur: dur
                          })
                          .save()
                          .then(function(distance){
                            console.log("Distance entry: " + distance);
                            callback(null, distance);
                          });
                      }); // end res.on('end')
                      }); // end https.get();
                    }
                  ],
                  function(err, results){
                    console.log("Error: " + err);
                    console.log("Waterfall results: " + results);
                    eachCallback();
                  }) // end waterfall
                } // end eachSeries with eachCallback()
                , function(){
                callback(null, application);
              });  // end entire eachSeries with second callback
            } else {
              callback(null, false);
            }
          }, // end of last waterfall function, distances calculated and stored
//ok
          // GPs
          function(application, callback){
              if(application){
                // retrieve a list of all schools of all types
                GPs.forge()
                .fetch()
                .then(function(gps){
                    // pass to calculate distances
                    callback(null, application, gps.toJSON());
                })

              } else{
                  callback(null, false, false);
              }
            } // pass application and all supermarkets to calculate distances
            ,
//ok
          function(application, gps, callback){
            if(application){
              console.log("Pre JSON GPs: " + gps);
              console.log("GPs: " + JSON.stringify(gps));
              console.log("Application ID: " + application['id']);
              console.log("Application ID: " + JSON.stringify(application));
              // for each destination, make call to distance

              async.eachSeries(gps, function(gp, eachCallback){
                async.waterfall([
                  function(callback){
                    console.log("GP: " + gp)
                    console.log("GP ID: " + gp['id']);
                    console.log("Application ID: " + application['id']);

                    host = "maps.googleapis.com";
                    apiKey = "AIzaSyDzF8M6_0H_Gf4POLQ8tw1fG9PL38aWRKQ";
                    endpoint = "/maps/api/distancematrix/json?";
                    path = "origins="+application['lat']+","+application['lon']+"&destinations="+gp['lat']+","+gp['lon']+"&key=";

                    options = {
                      host: host,
                      path: endpoint+path+apiKey
                    };

                    https.get(options,function(res){

                      var data = "";
                      res.on("data", function(chunk){
                        data += chunk;
                      });
                      res.on("end", function(){
                        var responseObject = JSON.parse(data);
                        console.log(responseObject);
                        var dist = responseObject["rows"][0]["elements"][0]["distance"]["value"];
                        var dur = responseObject["rows"][0]["elements"][0]["duration"]["value"];
                        Distance.forge({
                          origID: application['id'],
                          destID: gp['id'],
                          destType: "GP",
                          dist: dist,
                          dur: dur
                        })
                        .save()
                        .then(function(distance){
                          console.log("Distance entry: " + distance);
                          callback(null, distance);
                        });
                    }); // end res.on('end')
                    }); // end https.get();
                  }
                ],
                function(err, results){
                  console.log("Error: " + err);
                  console.log("Waterfall results: " + results);
                  eachCallback();
                }) // end waterfall
              } // end eachSeries with eachCallback()
              , function(){
              callback(null, application);
            });  // end entire eachSeries with second callback
          } else {
            callback(null, false);
          }
        }, // end of last waterfall function, distances calculated and stored

          // Green Spaces
          function(application, callback){
              if(application){
                // retrieve a list of all schools of all types
                GreenSpaces.forge()
                .fetch()
                .then(function(greenspaces){
                    // pass to calculate distances
                    callback(null, application, greenspaces.toJSON());
                })

              } else{
                  callback(null, false, false);
              }
            } // pass application and all supermarkets to calculate distances
            ,
          function(application, greenspaces, callback){
            if(application){
              console.log("Pre JSON GreenSpaces: " + greenspaces);
              console.log("GreenSpaces: " + JSON.stringify(greenspaces));
              console.log("Application ID: " + application['id']);
              console.log("Application ID: " + JSON.stringify(application));
              // for each destination, make call to distance

              async.eachSeries(greenspaces, function(greenspace, eachCallback){
                async.waterfall([
                  function(callback){
                    console.log("GreenSpace: " + greenspace)
                    console.log("GreenSpace ID: " + greenspace['id']);
                    console.log("Application ID: " + application['id']);

                    host = "maps.googleapis.com";
                    apiKey = "AIzaSyDzF8M6_0H_Gf4POLQ8tw1fG9PL38aWRKQ";
                    endpoint = "/maps/api/distancematrix/json?";
                    path = "origins="+application['lat']+","+application['lon']+"&destinations="+greenspace['lat']+","+greenspace['lon']+"&key=";

                    options = {
                      host: host,
                      path: endpoint+path+apiKey
                    };

                    https.get(options,function(res){

                      var data = "";
                      res.on("data", function(chunk){
                        data += chunk;
                      });
                      res.on("end", function(){
                        var responseObject = JSON.parse(data);
                        console.log(responseObject);
                        var dist = responseObject["rows"][0]["elements"][0]["distance"]["value"];
                        var dur = responseObject["rows"][0]["elements"][0]["duration"]["value"];
                        Distance.forge({
                          origID: application['id'],
                          destID: greenspace['id'],
                          destType: "GreenSpace",
                          dist: dist,
                          dur: dur
                        })
                        .save()
                        .then(function(distance){
                          console.log("Distance entry: " + distance);
                          callback(null, distance);
                        });
                    }); // end res.on('end')
                    }); // end https.get();
                  }
                ],
                function(err, results){
                  console.log("Error: " + err);
                  console.log("Waterfall results: " + results);
                  eachCallback();
                }) // end waterfall
                } // end eachSeries with eachCallback()
                , function(){
                callback(null, application);
                });  // end entire eachSeries with second callback
                } else {
                callback(null, false);
                }
                }, // end of last waterfall function, distances calculated and stored
// ok
          // Schools
          function(application, callback){
              if(application){
                // retrieve a list of all schools of all types
                Schools.forge()
                .fetch()
                .then(function(schools){
                    // pass to calculate distances
                    callback(null, application, schools.toJSON());
                })

              } else{
                  callback(null, false, false);
              }
            } // pass application and all supermarkets to calculate distances
            ,
          function(application, schools, callback){
            if(application){
              console.log("Pre JSON Schools: " + schools);
              console.log("Schools: " + JSON.stringify(schools));
              console.log("Application ID: " + application['id']);
              console.log("Application ID: " + JSON.stringify(application));
              // for each destination, make call to distance

              async.eachSeries(schools, function(school, eachCallback){
                async.waterfall([
                  function(callback){
                    console.log("School: " + school)
                    console.log("School ID: " + school['id']);
                    console.log("Application ID: " + application['id']);

                    host = "maps.googleapis.com";
                    apiKey = "AIzaSyDzF8M6_0H_Gf4POLQ8tw1fG9PL38aWRKQ";
                    endpoint = "/maps/api/distancematrix/json?";
                    path = "origins="+application['lat']+","+application['lon']+"&destinations="+school['lat']+","+school['lon']+"&key=";

                    options = {
                      host: host,
                      path: endpoint+path+apiKey
                    };

                    https.get(options,function(res){

                      var data = "";
                      res.on("data", function(chunk){
                        data += chunk;
                      });
                      res.on("end", function(){
                        var responseObject = JSON.parse(data);
                        console.log(responseObject);
                        var dist = responseObject["rows"][0]["elements"][0]["distance"]["value"];
                        var dur = responseObject["rows"][0]["elements"][0]["duration"]["value"];
                        Distance.forge({
                          origID: application['id'],
                          destID: school['id'],
                          destType: "School",
                          dist: dist,
                          dur: dur
                        })
                        .save()
                        .then(function(distance){
                          console.log("Distance entry: " + distance);
                          callback(null, distance);
                        });
                    }); // end res.on('end')
                    }); // end https.get();
                  }
                ],
                function(err, results){
                  console.log("Error: " + err);
                  console.log("Waterfall results: " + results);
                  eachCallback();
                }) // end waterfall
              } // end eachSeries with eachCallback()
              , function(){
              callback(null, application);
            });  // end entire eachSeries with second callback
          } else {
            callback(null, false);
          }
        }, // end of last waterfall function, distances calculated and stored

        // Applications
        function(application, callback){
            if(application){
              // retrieve a list of all schools of all types
              Applications.forge()
              .fetch()
              .then(function(applications){
                  // pass to calculate distances
                  callback(null, application, applications.toJSON());
              })

            } else{
                callback(null, false, false);
            }
          } // pass application and all supermarkets to calculate distances
          ,
        function(application, applications, callback){
          if(application){
            console.log("Pre JSON Applications: " + applications);
            console.log("Applications: " + JSON.stringify(applications));
            console.log("Application ID: " + application['id']);
            console.log("Application ID: " + JSON.stringify(application));
            // for each destination, make call to distance

            async.eachSeries(applications, function(application2, eachCallback){
              async.waterfall([
                function(callback){
                  console.log("application2: " + application2)
                  console.log("application2 ID: " + application2['id']);
                  console.log("Application ID: " + application['id']);

                  host = "maps.googleapis.com";
                  apiKey = "AIzaSyDzF8M6_0H_Gf4POLQ8tw1fG9PL38aWRKQ";
                  endpoint = "/maps/api/distancematrix/json?";
                  path = "origins="+application['lat']+","+application['lon']+"&destinations="+application2['lat']+","+application2['lon']+"&key=";

                  options = {
                    host: host,
                    path: endpoint+path+apiKey
                  };

                  https.get(options,function(res){

                    var data = "";
                    res.on("data", function(chunk){
                      data += chunk;
                    });
                    res.on("end", function(){
                      var responseObject = JSON.parse(data);
                      console.log(responseObject);
                      var dist = responseObject["rows"][0]["elements"][0]["distance"]["value"];
                      var dur = responseObject["rows"][0]["elements"][0]["duration"]["value"];
                      Distance.forge({
                        origID: application['id'],
                        destID: application2['id'],
                        destType: "Application",
                        dist: dist,
                        dur: dur
                      })
                      .save()
                      .then(function(distance){
                        console.log("Distance entry: " + distance);
                        callback(null, distance);
                      });
                  }); // end res.on('end')
                  }); // end https.get();
                }
              ],
              function(err, results){
                console.log("Error: " + err);
                console.log("Waterfall results: " + results);
                eachCallback();
              }) // end waterfall
            } // end eachSeries with eachCallback()
            , function(){
            callback(null, application);
          });  // end entire eachSeries with second callback
        } else {
          callback(null, false);
        }
      }, // end of last waterfall function, distances calculated and stored


        ],
        function(err, results){
          console.log("Error: " + err);
          console.log("Waterfall results: " + results);
          eachCallback();
        }); // end of waterfall embedded in eachseries for applications
      } // end of eachSeries that loops through entered applications
    );
        res.send(req.body); // end api by sending back the files that were loaded
      }); // end of the api call



// Load School
app.post('/loadSchools', function (req, res) {
      // Alows data to be downloaded from the server with security concerns
      res.header("Access-Control-Allow-Origin", "*");
      res.header("Access-Control-Allow-Headers", "X-Requested-WithD");
      // grab JSON from request
      var responseJSON = req.body;
      console.log(responseJSON);
      // for each item in the JSON:
      //// add to application database
      //// call for distance calculation
      async.eachSeries(responseJSON, function(item,eachCallback){
        async.waterfall([
          function(callback){
            // add to applications database
            if(item['lat'] != null && item['lon'] != null && item['name'] != null && item['level'] != null && item['public'] != null){
              School.forge({
                lat: item['lat'],
                lon: item['lon'],
                name: item['name'],
                level: item['level'],
                public: item['public']
              })
              .save()
              .then(function(collection){
                  // retain result and pass to next step
                  callback(null, collection.toJSON());
              })
              .catch(function(err){
                  // pass error to next step
                  callback(null, err.message);
              });
            } else {
              console.log("Didn't run")
              callback(null, false)
            }


          },
          function(school, callback){

            // retrieve a list of all destinations of all types
            console.log("School being entered: " + school);
            // pass to next function in waterfall

            var origins = [];
            // calculate distance to all destinations
            callback(null, school, origins)

          },
          function(school, origins, callback){

              callback(null, school)
        }],
        function(err, results){
          console.log("Error: " + err);
          console.log("Waterfall results: " + results);
          eachCallback();
        });
      });

        res.send(req.body); // end api by sending back the files that were loaded
      }); // end of the api call

// Load GPs
app.post('/loadGPs', function (req, res) {
      // Alows data to be downloaded from the server with security concerns
      res.header("Access-Control-Allow-Origin", "*");
      res.header("Access-Control-Allow-Headers", "X-Requested-WithD");
      // grab JSON from request
      var responseJSON = req.body;
      console.log(responseJSON);
      // for each item in the JSON:
      //// add to application database
      //// call for distance calculation
      async.eachSeries(responseJSON, function(item,eachCallback){
        async.waterfall([
          function(callback){
            // add to applications database
            if(item['lat'] != null && item['lon'] != null && item['name'] != null){
              GP.forge({
                lat: item['lat'],
                lon: item['lon'],
                name: item['name']
              })
              .save()
              .then(function(collection){
                  // retain result and pass to next step
                  callback(null, collection.toJSON());
              })
              .catch(function(err){
                  // pass error to next step
                  callback(null, err.message);
              });
            } else {
              console.log("Didn't run")
              callback(null, false)
            }


          },
          function(gp, callback){

            // retrieve a list of all destinations of all types
            console.log("GP being entered: " + gp);
            // pass to next function in waterfall

            var origins = [];
            // calculate distance to all destinations
            callback(null, gp, origins)

          },
          function(gp, origins, callback){
              callback(null, gp)
        }],
        function(err, results){
          console.log("Error: " + err);
          console.log("Waterfall results: " + results);
          eachCallback();
        });
      });

        res.send(req.body); // end api by sending back the files that were loaded
      }); // end of the api call

// Load GreenSpaces
app.post('/loadGreenSpaces', function (req, res) {
      // Alows data to be downloaded from the server with security concerns
      res.header("Access-Control-Allow-Origin", "*");
      res.header("Access-Control-Allow-Headers", "X-Requested-WithD");
      // grab JSON from request
      var responseJSON = req.body;
      console.log(responseJSON);
      // for each item in the JSON:
      //// add to application database
      //// call for distance calculation
      async.eachSeries(responseJSON, function(item,eachCallback){
        async.waterfall([
          function(callback){
            // add to applications database
            if(item['lat'] != null && item['lon'] != null && item['name'] != null && item['area'] != null){
              GreenSpace.forge({
                lat: item['lat'],
                lon: item['lon'],
                name: item['name'],
                area: item['area']
              })
              .save()
              .then(function(collection){
                  // retain result and pass to next step
                  callback(null, collection.toJSON());
              })
              .catch(function(err){
                  // pass error to next step
                  callback(null, err.message);
              });
            } else {
              console.log("Didn't run")
              callback(null, false)
            }


          },
          function(greenSpace, callback){

            // retrieve a list of all destinations of all types
            console.log("Green space being entered: " + greenSpace);
            // pass to next function in waterfall

            var origins = [];
            // calculate distance to all destinations
            callback(null, greenSpace, origins)

          },
          function(greenSpace, origins, callback){

              callback(null, greenSpace)
        }],
        function(err, results){
          console.log("Error: " + err);
          console.log("Waterfall results: " + results);
          eachCallback();
        });
      });

        res.send(req.body); // end api by sending back the files that were loaded
      }); // end of the api call


// Load GreenSpaces
app.post('/loadSupermarkets', function (req, res) {
      // Alows data to be downloaded from the server with security concerns
      res.header("Access-Control-Allow-Origin", "*");
      res.header("Access-Control-Allow-Headers", "X-Requested-WithD");
      // grab JSON from request
      var responseJSON = req.body;
      console.log(responseJSON);
      // for each item in the JSON:
      //// add to application database
      //// call for distance calculation
      async.eachSeries(responseJSON, function(item,eachCallback){
        async.waterfall([
          function(callback){
            // add to applications database
            if(item['lat'] != null && item['lon'] != null && item['name'] != null && item['type'] != null){
              Supermarket.forge({
                lat: item['lat'],
                lon: item['lon'],
                name: item['name'],
                type: item['type']
              })
              .save()
              .then(function(collection){
                  // retain result and pass to next step
                  callback(null, collection.toJSON());
              })
              .catch(function(err){
                  // pass error to next step
                  callback(null, err.message);
              });
            } else {
              console.log("Didn't run")
              callback(null, false)
            }


          },
          function(supermarket, callback){

            // retrieve a list of all destinations of all types
            console.log("Supermarket being entered: " + supermarket);
            // pass to next function in waterfall

            var origins = [];
            // calculate distance to all destinations
            callback(null, supermarket, origins)

          },
          function(supermarket, origins, callback){

              callback(null, supermarket)
        }],
        function(err, results){
          console.log("Error: " + err);
          console.log("Waterfall results: " + results);
          eachCallback();
        });
      });

        res.send(req.body); // end api by sending back the files that were loaded
      }); // end of the api call

// Clustering
// https://github.com/uhho/density-clustering/blob/master/lib/OPTICS.js
// Edit distance function to search inside of a matrix that has been passed

      // frontend routes =========================================================
    	// route to handle all angular requests
      app.get('*', function(req, res) {
        res.sendfile('./public/index.html');
      });
};
