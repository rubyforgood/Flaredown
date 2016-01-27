/*jshint node:true*/
/* global require, module */
var EmberApp = require('ember-cli/lib/broccoli/ember-app');

module.exports = function(defaults) {
  var app = new EmberApp(defaults, {
    dotEnv: {
      path: {
        development: '../backend/.env',
      }
    }
  });

  // pace
  app.import('bower_components/pace/pace.js');

  // spinkit
  app.import('bower_components/spinkit/css/spinners/7-three-bounce.css');

  // pusher
  app.import('bower_components/pusher/dist/pusher.js');

  return app.toTree();
};
