// Schemas

var Schema = {
  applications: {
      id: {type: 'increments', nullable: false, primary: true},
      Planning_Authority: { type: 'string', maxlength: 254, nullable: false},
      Borough_Ref: { type: 'string', maxlength: 254, nullable: false},
      Permission_Status: { type: 'string', maxlength: 254, nullable: false},
      Permission_Date:{ type: 'datetime' , nullable: false},
      Post_Code: { type: 'string', maxlength: 254, nullable: false},
      Total_Residential_Units: {type: 'float', nullable: false},
      Proposed_Total_Aff_Per: {type: 'float', nullable: false},
      lat: {type: 'float', nullable: false, precision: 10, scale:6},
      lon: {type: 'float', nullable: false, precision: 10, scale:6},
      Total_Aff_Units: {type: 'float', nullable: false},
      Cluster_ID: {type: 'float', nullable: false},
      Housing_Density:{type: 'float', nullable: false},
  },
  supermarkets: {
      id: {type: 'increments', nullable: false, primary: true},
      Retailer: {type: 'string', maxlength: 254, nullable: false},
      lat: {type: 'float', nullable: false, precision: 10, scale:6},
      lon: {type: 'float', nullable: false, precision: 10, scale:6},
  },
  greenSpaces: {
      id: {type: 'increments', nullable: false, primary: true},
      lat: {type: 'float', nullable: false, precision: 10, scale:6},
      lon: {type: 'float', nullable: false, precision: 10, scale:6},
      //name: {type: 'string', maxlength: 254, nullable: true},
      //area: {type: 'float', nullable: false}
  },
  gps: {
      id: {type: 'increments', nullable: false, primary: true},
      Ward_Name:{type: 'string', maxlength: 254, nullable: false},
      GPs: {type: 'float', nullable: false},
      lat: {type: 'float', nullable: false, precision: 10, scale:6},
      lon: {type: 'float', nullable: false, precision: 10, scale:6},
  },
  schools: {
      id: {type: 'increments', nullable: false, primary: true},
      Name: {type: 'string', maxlength: 254, nullable: false},
      Type: {type: 'string', maxlength: 254, nullable:false},
      Age_Group: {type: 'string', maxlength: 254, nullable:false},
      lat: {type: 'float', nullable: false, precision: 10, scale:6},
      lon: {type: 'float', nullable: false, precision: 10, scale:6},
  },
  distances2: {
      origId: {type: 'integer', nullable: false},
      destId: {type: 'integer', nullable: false},
      destType: {type: 'string', maxlength: 150, nullable:false},
      dist: {type: 'float', nullable: false, precision:8, scale:2},
      dur: {type: 'float', nullable: false, precision:8, scale:2}
  }
};

module.exports = Schema;
