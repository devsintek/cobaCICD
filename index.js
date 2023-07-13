const https = require('https');
const fs = require('fs');

const options = {
  key: fs.readFileSync('private.key'),
  cert: fs.readFileSync('certificate.crt')
};

const server = https.createServer(options, (req, res) => {
  res.writeHead(200);
  res.end('Hi beb...');
});

server.listen(62303, () => {
  console.log('HTTPS server listening on port ...');
});
