/*jshint node:true*/
module.exports = {
  "framework": "qunit",
  "test_page": "tests/index.html?hidepassed",
  "disable_watching": true,
   "launchers": {
    "AltPhantom": {
      "exe": "phantomjs",
      "args": ["tests/phantom-runner.js"],
      "protocol": "browser"
    }
  },
  "launch_in_ci": [
    "AltPhantom"
  ],
  "launch_in_dev": [
    "PhantomJS",
    "Chrome"
  ]
};
