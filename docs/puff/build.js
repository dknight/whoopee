import {
  writeFileSync,
  readFileSync,
  createReadStream,
  createWriteStream,
  statSync,
  mkdirSync,
} from 'node:fs';
import path from 'node:path';
import {createGzip} from 'node:zlib';
import {promisify} from 'node:util';
import {pipeline} from 'node:stream';
import replace from 'replace-in-file';

import browserslist from 'browserslist';
import {browserslistToTargets, bundle, Features} from 'lightningcss';

const projectName = 'puff';

const srcDir = 'src';
const distDir = 'dist';
const inputFile = `${projectName}.css`;
const outputFile = `${projectName}.min.css`;
const input = path.join('.', srcDir, inputFile);
const output = path.join('.', distDir, inputFile);
const outputMin = path.join('.', distDir, outputFile);

try {
  mkdirSync(distDir);
} catch (e) {
  // console.warn(e);
}

const targets = browserslistToTargets(browserslist('>= 0.25%'));

let bundleStuct = bundle({
  filename: input,
  minify: false,
  include: Features.Colors,
  exclude: Features.Nesting,
  targets,
});

writeFileSync(output, bundleStuct.code);

bundleStuct = bundle({
  filename: output,
  minify: true,
});

writeFileSync(outputMin, bundleStuct.code);

const zip = async (input, output) => {
  const gzip = createGzip({
    level: 9,
  });
  const source = createReadStream(input);
  const destination = createWriteStream(output);
  const pipe = promisify(pipeline);
  await pipe(source, gzip, destination);
  const insize = statSync(input).size;
  const outsize = statSync(output).size;
  return Promise.resolve([insize, outsize]);
};

zip(outputMin, `${outputMin}.gz`)
  .then((sizes) => {
    console.log(`Normal: ${sizes[0]} bytes`);
    console.log(`Gzip: ${sizes[1]} bytes`);
  })
  .catch((err) => {
    console.error(`Cannot zip file: ${err}`);
    process.exit(1);
  });

// write version
const packageContents = readFileSync(path.join(process.cwd(), 'package.json'));
let env;
try {
  env = JSON.parse(packageContents);
} catch (e) {
  console.error('Cannot parse package.json', e);
  process.exit(1);
}
const version = process.env.BUILD_VERSION || env.version;
const replaceOpts = {
  from: /v\d+\.\d+\.\d+/g,
  to: `v${version}`,
  files: path.join(process.cwd(), 'docs', 'index.html'),
};
try {
  replace.sync(replaceOpts);
  // console.log('Replacement results:', results);
} catch (error) {
  console.error('Error occurred:', error);
}
