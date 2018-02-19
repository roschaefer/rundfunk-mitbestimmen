(function() {
  function vendorModule() {
    'use strict';

    return {
      'default': self['d3'],
      __esModule: true,
    };
  }

  define('d3', [], vendorModule);
})();
