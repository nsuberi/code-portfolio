// Origin Model

// TEST WHETHER KNEX CALL IS REQUIRED HERE... MIGHT BREAK IT TO HAVE TWO CALLS

var knex = require('knex')({
    client: 'mysql',
    connection: {
        host     : '128.40.150.34',
        user     : 'ucfnnsu',
        password : 'xijaxiheya',
        database : 'ucfnnsu',
        charset  : 'utf8'
  }
});

var Bookshelf = require('bookshelf')(knex);

// Application model
var Application = Bookshelf.Model.extend({
    tableName: 'applications'
});
// Supermarket model
var Supermarket = Bookshelf.Model.extend({
    tableName: 'supermarkets',
});
// GP model
var GP = Bookshelf.Model.extend({
    tableName: 'gps'
});
// School model
var School = Bookshelf.Model.extend({
    tableName: 'schools',
});
// GreenSpace model
var GreenSpace = Bookshelf.Model.extend({
    tableName: 'greenSpaces'
});
// Distance model
var Distance = Bookshelf.Model.extend({
    tableName: 'distances2',
});


// Application Collection
var Applications = Bookshelf.Collection.extend({
    model: Application
});
// Supermarket Collection
var Supermarkets = Bookshelf.Collection.extend({
    model: Supermarket
});
// GP Collection
var GPs = Bookshelf.Collection.extend({
    model: GP
});
// School Collection
var Schools = Bookshelf.Collection.extend({
    model: School
});
// GreenSpace Collection
var GreenSpaces = Bookshelf.Collection.extend({
    model: GreenSpace
});
// Distance Collection
var Distances = Bookshelf.Collection.extend({
    model: Distance
});

module.exports = {
  Application: Application,
  Applications: Applications,

  Supermarket: Supermarket,
  Supermarkets: Supermarkets,

  GP: GP,
  GPs: GPs,

  School: School,
  Schools: Schools,

  GreenSpace: GreenSpace,
  GreenSpaces: GreenSpaces,

  Distance: Distance,
  Distances: Distances,

  knex: knex
}
