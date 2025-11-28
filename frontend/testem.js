/*jshint node:true*/
module.exports = {
  "framework": "qunit",
  "test_page": "tests/index.html?hidepassed",
  "disable_watching": true,
  "launch_in_ci": [
    "Chrome"
  ],
  "browser_args": {
    "Chrome": [
      "--headless",
      "--disable-gpu",
      "--remote-debugging-port=9222",
      "--window-size=1440,900"
    ]
  },
  "launch_in_dev": [
    "PhantomJS",
    "Chrome"
  ],
  "proxies": {
    "/api": {
      "target": "http://localhost:3000"
    }
  }
};
