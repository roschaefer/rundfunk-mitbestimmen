module.exports = function(deployTarget) {
  var ENV = {
    build: {}
    // include other plugin configuration that applies to all deploy targets here
  };

  if (deployTarget === 'development') {
    ENV.build.environment = 'development';
    // configure other plugins for development deploy target here
  }

  if (deployTarget === 'staging') {
    ENV.build.environment = 'staging';
    ENV['scp'] = {
      nodes: [{
        username: 'rschafer',
        host: 'roschaefer.de',
        path: '/home/rschafer/rundfunk-frontend/dist'
      }]
    }
    // configure other plugins for staging deploy target here
  }

  if (deployTarget === 'production') {
    ENV.build.environment = 'production';
    ENV['scp'] = {
      nodes: [{
        username: 'rfmb',
        host: 'rundfunk-mitbestimmen.de',
        path: '/home/rfmb/rundfunk-frontend/dist/'
      }]
    }
  }

  // Note: if you need to build some configuration asynchronously, you can return
  // a promise that resolves with the ENV object instead of returning the
  // ENV object synchronously.
  return ENV;
};
