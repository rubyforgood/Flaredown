/*jshint node:true*/
/* global require, module */
var EmberApp = require('ember-cli/lib/broccoli/ember-app');

module.exports = function(defaults) {
  var app = new EmberApp(defaults, {
    dotEnv: {
      path: {
        development: '../backend/.env',
      }
    },

    sassOptions: {
      includePaths: [
        'bower_components/spinkit/scss'
      ]
    }
  });

  // pace
  app.import(app.bowerDirectory + '/pace/pace.js');

  // pusher
  app.import(app.bowerDirectory + '/pusher/dist/pusher.js');

  // d3
  app.import(app.bowerDirectory + '/d3/d3.min.js');

  // MomentJS
  app.import(app.bowerDirectory + '/momentjs/moment.js');
  app.import(app.bowerDirectory + '/moment-range/dist/moment-range.js');

  return app.toTree();
};
