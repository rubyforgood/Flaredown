'use strict';

const fs = require('fs');
const express = require('express');
const cluster = require('express-cluster');
const fastbootMiddleware = require('fastboot-express-middleware');
const parseArgs = require('minimist');
const staticGzip = require('express-serve-static-gzip');
const sabayon = require('express-sabayon');
const http = require('http');
const webp = require('webp-middleware');
const path = require('path');

const assetPath = process.env.DIST || 'tmp/deploy-dist'
const port = process.env.PORT || 4300;

console.log('Booting Ember app...', process.env.DIST);

try {
  fs.accessSync(assetPath, fs.F_OK);
} catch (e) {
  console.error(`The asset path ${assetPath} does not exist.`);
  process.exit(1);
}

console.log('Ember app booted successfully.');

cluster(function() {
  var app = express();

  var fastboot = fastbootMiddleware(assetPath);

  if (assetPath) {
    app.get('/', fastboot);
    app.use(staticGzip(assetPath));

    const cacheDir = path.join(__dirname, 'tmp', 'webp-cache');

    app.use(webp(assetPath, {
      quality: 80,
      cacheDir: cacheDir
    }));
    app.use(express.static(assetPath));
  }

  app.get(sabayon.path, sabayon.middleware());
  app.get('/*', fastboot);

  var listener = app.listen(port, function() {
    var host = listener.address().address;
    var port = listener.address().port;
    var family = listener.address().family;

    if (family === 'IPv6') { host = '[' + host + ']'; }

    console.log('Ember FastBoot running at http://' + host + ":" + port);
  });
}, { verbose: true });
