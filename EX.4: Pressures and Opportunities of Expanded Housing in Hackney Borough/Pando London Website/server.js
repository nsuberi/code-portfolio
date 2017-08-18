// Server
// modules =================================================
var express        = require('express');
var app            = express();
var bodyParser     = require('body-parser');
var methodOverride = require('method-override');
var querystring = require('querystring');
var mysql = require('mysql');
var csv = require('csv');
var async = require('async');
//var knex = require('knex');
var knex = require('./app/models/ModelsCollections')["knex"];

// Portnumber for API
var portNumber = 8899;

// BodyParser
app.use(bodyParser.json({limit: '50mb'})); // parse application/json
app.use(bodyParser.json({ type: 'application/vnd.api+json' })); // parse application/vnd.api+json as json
app.use(bodyParser.urlencoded({ extended: true })); // parse application/x-www-form-urlencoded
// Set directory with express statement
// UNCLEAR = what override does?
app.use(methodOverride('X-HTTP-Method-Override')); // override with the X-HTTP-Method-Override header in the request. simulate DELETE/PUT
app.use(express.static(__dirname + '/public')); // set the static files location /public/img will be /img for users

// routes ==================================================
require('./app/routes')(app); // pass our application into our routes

// Setup the server and print a string to the screen when server is ready
var server = app.listen(portNumber, function () {
  var host = server.address().address;
  var port = server.address().port;
  console.log('App listening at http://%s:%s', host, port);
});
exports = module.exports = app; 						// expose app

// Close connection do database on Ctrl-C
process.on('SIGINT', function() {
    knex.client.pool.destroy();
    // https://github.com/tgriesser/knex/blob/8480c0fa0425da89393cd108cb267554dd6c05c0/lib/cli/migrate.js#L117
    knex.destroy(function(){
      console.log(knex)
      process.exit();
    });

});
