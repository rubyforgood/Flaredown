'use strict';

const map = require('broccoli-stew').map;
const Funnel = require('broccoli-funnel');

var EmberApp = require('ember-cli/lib/broccoli/ember-app');

module.exports = function(defaults) {
  var app = new EmberApp(defaults, {
    babel: {
      sourceMaps: 'inline'
    },

    'ember-cli-babel': {},

    dotEnv: {
      path: {
        development: '../backend/.env',
      }
    },

    sassOptions: {
      includePaths: [
        'node_modules/bourbon/core',
        'node_modules/bourbon-neat/core',
      ]
    },

    fingerprint: {
      exclude: [
        'weather/clear-day',
        'weather/clear-night',
        'weather/cloudy',
        'weather/default',
        'weather/fog',
        'weather/partly-cloudy-day',
        'weather/partly-cloudy-night',
        'weather/rain',
        'weather/sleet',
        'weather/snow',
        'weather/wind',
      ],
    },

    svg: {
      paths: [
        'public/assets/nav_icons',
      ],

      optimize: {
        plugins: [
          { removeDoctype: false },
          { removeTitle: true },
          { removeDesc: true },
        ],
      },
    },
  });

  const assetPath = process.env.PWD + '/' + app.bowerDirectory;

  let vendorLib = new Funnel(assetPath, {
    files: [
      '/pace/pace.js',
      '/drag-drop-polyfill/release/drag-drop-polyfill.js',
    ],
    destDir: '/assets',
  });

  vendorLib = map(vendorLib, (content) => `if (typeof FastBoot === 'undefined') { ${content} \n }`);

  // Spinkit
  app.import('node_modules/spinkit/spinkit.css')

  // d3
  app.import(app.bowerDirectory + '/d3/d3.min.js');

  // HTML5 Drag and Drop Polyfill for Mobile
  app.import(app.bowerDirectory + '/drag-drop-polyfill/release/drag-drop-polyfill-scroll-behaviour.js');
  app.import(app.bowerDirectory + '/drag-drop-polyfill/release/drag-drop-polyfill.css');
  app.import(app.bowerDirectory + '/drag-drop-polyfill/release/drag-drop-polyfill-icons.css');

  // At-js
  app.import(app.bowerDirectory + '/At.js/dist/css/jquery.atwho.css');

  return app.toTree([vendorLib]);
};
