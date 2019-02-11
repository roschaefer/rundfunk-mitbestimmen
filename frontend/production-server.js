const FastBootAppServer = require('fastboot-app-server');
const ExpressHTTPServer = require('fastboot-app-server/src/express-http-server');
const proxy = require('http-proxy-middleware')

const httpServer = new ExpressHTTPServer(/* {options} */);
const app = httpServer.app;
app.use('/api', proxy({
  target: process.env.BACKEND_URL || 'http://localhost:3000',
  pathRewrite: { '^/api': '' },
  changeOrigin: true
}))

let server = new FastBootAppServer({
  httpServer: httpServer,
  distPath: 'dist',
  gzip: true, // Optional - Enables gzip compression.
  host: '0.0.0.0', // Optional - Sets the host the server listens on.
  // port: 4000, // Optional - Sets the port the server listens on (defaults to the PORT env var or 3000).
  // sandboxGlobals: { GLOBAL_VALUE: MY_GLOBAL }, // Optional - Make values available to the Ember app running in the FastBoot server, e.g. "MY_GLOBAL" will be available as "GLOBAL_VALUE"
  // chunkedResponse: true // Optional - Opt-in to chunked transfer encoding, transferring the head, body and potential shoeboxes in separate chunks. Chunked transfer encoding should have a positive effect in particular when the app transfers a lot of data in the shoebox.
});

server.start();
