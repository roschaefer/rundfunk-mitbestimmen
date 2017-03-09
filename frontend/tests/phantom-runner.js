/*jslint node: true */
// Custom version of the Testem PhantomJS runner.
//   This exists to block requests to fonts.googleapis.com because this can cause
//     Phantom to incompletely load JS files causing bizarre syntax errors.
//   See https://github.com/ariya/phantomjs/issues/14173.
var system = require('system');
var page = require('webpage').create();
var url = system.args[1];
page.viewportSize = {
  width: 1024,
  height: 768
};
// The magic!
page.onResourceRequested = function(requestData, networkRequest) {
  if (requestData.url.match('fonts.googleapis.com')) {
    networkRequest.abort();
  }
};
page.open(url);
