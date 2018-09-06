// Modern web-development is sucks!
// Required needed stuff.
// If you dont have package.json file. run
// $npm install -D 'package-name'
// for each of them.
let gulp         = require('gulp'),
    postcss      = require('gulp-postcss'),
    autoprefixer = require('autoprefixer'),
    sass         = require("gulp-sass"),
    babel        = require('gulp-babel'),
    sourcemaps   = require('gulp-sourcemaps'),
    concat       = require('gulp-concat'),
    uglify       = require('gulp-uglify'),
    cssMin       = require('gulp-minify-css')
    pug          = require('gulp-pug');


// Run from terminal $NODE_ENV=production gulp
const IS_PROD = (process.env.NODE_ENV === 'production');

// File paths
let styleFiles  = __dirname + '/src/css/**/*.scss';
let jsFiles     = __dirname + '/src/js/**/*.js';
let viewsFiles  = __dirname + '/src/**/*.pug';
let htmlFiles   = __dirname + '/src/**/*.html';

// Build path
let distPath    = __dirname + '/build';

// Default gulp task
gulp.task('default', ['html', 'pug', 'stylesheets', 'scripts'], () => {
  // Some code here
});

// Process stylesheets, preprocess SASS, make postcss on them, concatenate all
// files and minify them. Profit?
gulp.task('stylesheets', () => {
  let postcssPlugins = [
    autoprefixer({ browsers: 'last 1 version' })
  ];
  return gulp.src(styleFiles)
      .pipe(sourcemaps.init())
      .pipe(sass({
        outputStyle: 'expanded'
      }).on('error', sass.logError))
      .pipe(postcss(postcssPlugins))
      .pipe(concat('all.css'))
      //.pipe(cssMin())
      .pipe(gulp.dest(distPath + '/stylesheets'));
});

// Process JS files. Babel - wow amazing shit! New crappy languages that
// transforms code into another crappy language (JavaScript).
gulp.task('scripts', () => {
  let jsbuild = gulp.src(jsFiles)
            .pipe(sourcemaps.init())
            .pipe(babel({
              presets: ['env']
            }));

  if (IS_PROD) {
    jsbuild.pipe(uglify())
  }

  return jsbuild
        .pipe(concat('bundle.js'))
        .pipe(gulp.dest(distPath + '/javascripts'));
});

// Pug templates is most stupid thing ever!
// Ugly, awkward as a dog of pug breed.
gulp.task('pug', () => {
  return gulp.src(viewsFiles)
            .pipe(pug({
              // options are here
            }))
            .pipe(gulp.dest(distPath));
});

// Just copy HTML files to dist
gulp.task('html', () => {
  return gulp.src(htmlFiles)
            .pipe(gulp.dest(distPath));
});

// Watch for changes.
// This might be useful function.
gulp.task('watch', () => {
  gulp.watch(styleFiles, ['stylesheets']);
  gulp.watch(jsFiles, ['scripts']);
  gulp.watch(viewsFiles, ['pug']);
  gulp.watch(htmlFiles, ['html']);
});