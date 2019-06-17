const express = require('express');
const yargs = require('yargs');

const argv = yargs
    .option('mount-path', {
        alias: 'm',
        default: '/docs',
        description: 'The root mount path to listen on, ex: --mount-path=/docs would mount the "public" directory on https://example.com/docs',
    })
    .option('port', {
        alias: 'p',
        default: 3000,
        description: 'The port to bind to and listen on'
    })
    .help()
    .alias('help', 'h')
    .argv;

const app = new express();
const mountPath = argv['mount-path'];
const port = argv.port;

console.log(`Starting static asset server, serving static asset directory "public" on ${mountPath}`);
console.log(`Navigate to localhost:${port}/docs/?service=\<OPENAPI SPEC NAME\> ... eg localhost:${port}/docs/?service=creditrisk`);
app.use(mountPath, express.static('public'));
app.listen(port, () => console.log(`Listening on port ${port}`));
