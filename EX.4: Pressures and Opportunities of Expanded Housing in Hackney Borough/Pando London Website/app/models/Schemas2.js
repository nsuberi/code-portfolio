// Schemas

var Schema = {
  applications: {
      id: {type: 'increments', nullable: false, primary: true},
      lat: {type: 'float', nullable: false},
      lon: {type: 'float', nullable: false},
      cluster: {type: 'integer', nullable: true},
      price: {type: 'float', nullable: true}
  },
  supermarkets: {
      id: {type: 'increments', nullable: false, primary: true},
      lat: {type: 'float', nullable: false},
      lon: {type: 'float', nullable: false},
      name: {type: 'string', maxlength: 254, nullable: false},
      type: {type: 'string', maxlength: 150, nullable: false}
  },
  greenSpaces: {
      id: {type: 'increments', nullable: false, primary: true},
      lat: {type: 'float', nullable: false},
      lon: {type: 'float', nullable: false},
      name: {type: 'string', maxlength: 254, nullable: true},
      area: {type: 'float', nullable: false}
  },
  gps: {
      id: {type: 'increments', nullable: false, primary: true},
      lat: {type: 'float', nullable: false},
      lon: {type: 'float', nullable: false},
      name: {type: 'string', maxlength: 254, nullable: true}
  },
  schools: {
      id: {type: 'increments', nullable: false, primary: true},
      lat: {type: 'float', nullable: false},
      lon: {type: 'float', nullable: false},
      name: {type: 'string', maxlength: 254, nullable: true},
      level: {type: 'string', maxlength: 150, nullable:true},
      public: {type: 'boolean', nullable: true}
  },
  distances2: {
      origId: {type: 'integer', nullable: false},
      destId: {type: 'integer', nullable: false},
      destType: {type: 'string', maxlength: 150, nullable:false},
      dist: {type: 'float', nullable: false},
      dur: {type: 'float', nullable: false}
  }
};

module.exports = Schema;
