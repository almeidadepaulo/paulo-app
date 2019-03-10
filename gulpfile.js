var gulp = require('gulp'),
    plugins = require('gulp-load-plugins')(),
    htmlbuild = require('gulp-htmlbuild'),
    es = require('event-stream'),
    less = require('gulp-less'),
    path = require('path'),
    replace = require('gulp-replace'),
    gulpSequence = require('gulp-sequence'),
    webserver = require('gulp-webserver'),
    jshint = require('gulp-jshint'),
    stylish = require('jshint-stylish'),
    watch = require('gulp-watch'),
    request = require('request'),
    clean = require('gulp-clean'),
    uglify = require('gulp-uglify'),
    concat = require('gulp-concat'),
    cssmin = require('gulp-cssmin'),
    livereload = require('gulp-livereload'),
    moment = require('moment'),
    rename = require("gulp-rename");

var projectBuild = '';
var version = (new Date()).getTime();
var projects = ['main',
    'publish',
    'collect',
    'securities',
    'genesys'
]

// https://www.npmjs.com/package/gulp-webserver
gulp.task('serve', ['watch'], function() {
    gulp.src('')
        .pipe(webserver({
            livereload: {
                enable: true,
                filter: function(fileName) {
                    // exclude all source maps from livereload
                    if (fileName.match(/LICENSE|\.json$|\.md|lib|rest|node_modules|build|pdf-viewer/)) {
                        return false;
                    } else {
                        return true;
                    }
                }
            },
            directoryListing: false,
            open: false,
            port: 8080
        }));
});

gulp.task('livereload', function() {
    gulp.src('src')
        .pipe(livereload());
});

gulp.task('watch', function() {
    livereload.listen();
    gulp.watch(['src/*.html',
        'src/*.js',
        'src/*.less',
        'src/*.css'
    ], { cwd: './' }, ['livereload']);

    for (var i = 0; i <= projects.length - 1; i++) {

        //gulp.watch('src/' + projects[i] + '/**/*.js', ['jshint']);
        gulp.watch('src/' + projects[i] + '/**/*.js', { cwd: './' }).on('change', function(event) {
            //console.log('File ' + event.path + ' was ' + event.type);
            //console.log(event.path.split('seeaway-app\\src\\')[1].split('\\')[0]);
            var projectChanged = event.path.split('seeaway-app\\src\\')[1].split('\\')[0];
            gulp.start('jshint-' + projectChanged);
            //gulp.start('jshint-' + projects[i - 1]);
        });

        gulp.watch(['src/' + projects[i] + '/directive/**/*.*',
            'src/' + projects[i] + '/partial/**/*.*',
            'src/' + projects[i] + '/service/**/*.*',
            'src/' + projects[i] + '/filter/**/*.*',
            'src/' + projects[i] + '/constant/**/*.*'
        ], { cwd: './' }, ['livereload']);
    }

    gulp.watch(['src/main/directive/**/*.*',
        'src/main/partial/**/*.*',
        'src/main/service/**/*.*',
        'src/main/filter/**/*.*',
        'src/main/constant/**/*.*'
    ], { cwd: './' }, ['livereload']);

    gulp.watch('src/*.js', ['jshint']);
    gulp.watch('backend/cf/**/*.cfc', { cwd: './' }, ['rest-cf-init']);
});

gulp.task('rest-cf-init', function() {
    var url = 'http://localhost:8500/seeaway-app/backend/cf/restInit.cfm'
    var start = moment();
    request(url, function(error, response, body) {
        if (!error && response.statusCode == 200) {
            console.log('[' + moment().format('hh:mm:ss') + ']', body);
        }
    })
});

gulp.task('jshint', function() {
    return gulp
        .src(['!src/build/**',
            '!src/lib/**',
            '!src/pdf-viewer/**',
            'src/**/*.js'
        ])
        .pipe(jshint())
        .pipe(jshint.reporter('jshint-stylish'));
});

gulp.task('jshint-main', function() {
    return gulp
        .src(['!src/build/**',
            '!src/lib/**',
            '!src/pdf-viewer/**',
            'src/main/**/*.js'
        ])
        .pipe(jshint())
        .pipe(jshint.reporter('jshint-stylish'));
});

gulp.task('jshint-collect', function() {
    return gulp
        .src(['!src/build/**',
            '!src/lib/**',
            '!src/pdf-viewer/**',
            'src/collect/**/*.js'
        ])
        .pipe(jshint())
        .pipe(jshint.reporter('jshint-stylish'));
});

gulp.task('jshint-publish', function() {
    return gulp
        .src(['!src/build/**',
            '!src/lib/**',
            '!src/pdf-viewer/**',
            'src/publish/**/*.js'
        ])
        .pipe(jshint())
        .pipe(jshint.reporter('jshint-stylish'));
});

gulp.task('jshint-securities', function() {
    return gulp
        .src(['!src/build/**',
            '!src/lib/**',
            '!src/pdf-viewer/**',
            'src/securities/**/*.js'
        ])
        .pipe(jshint())
        .pipe(jshint.reporter('jshint-stylish'));
})

gulp.task('jshint-genesys', function() {
    return gulp
        .src(['!src/build/**',
            '!src/lib/**',
            '!src/pdf-viewer/**',
            'src/genesys/**/*.js'
        ])
        .pipe(jshint())
        .pipe(jshint.reporter('jshint-stylish'));
});

// pipe a glob stream into this and receive a gulp file stream 
var gulpSrc = function(opts) {
    var paths = es.through();
    var files = es.through();

    paths.pipe(es.writeArray(function(err, srcs) {

        for (var i = 0; i <= srcs.length - 1; i++) {
            srcs[i] = 'src/' + srcs[i];
        }

        gulp.src(srcs, opts).pipe(files);
    }));

    return es.duplex(paths, files);
};

gulp.task('js-compress', function() {
    return gulp
        .src(['!src/build/js/*.min.js', 'src/build/js/*.js'])
        .pipe(uglify())
        .pipe(gulp.dest('src/build/js/'));
});

/*gulp.task('js-concat', function() {
    return gulp
        .src(['src/build/js/*.js'])
        .pipe(concat('concat.js'))
        .pipe(gulp.dest('src/build/js/'));
});*/

gulp.task('js-clean', function() {
    return gulp
        .src(['!src/build/js/concat.js', 'src/build/js/*.js'])
        .pipe(clean({ force: true }));
});

gulp.task('clean', function() {
    return gulp.src('src/build')
        .pipe(clean({ force: true }));
});

var jsBuild = es
    .pipeline(
        //uglify(),
        plugins.concat('concat_' + version + '.js'),
        gulp.dest('src/build/js')
    );

var cssBuild = es
    .pipeline(
        plugins.concat('concat.css'),
        gulp.dest('src/build/css')
    );


gulp.task('htmlbuild', function() {

    gulp.src(['src/' + projectBuild + '-index.html'])
        .pipe(htmlbuild({
            // build js with preprocessor 
            js: htmlbuild.preprocess.js(function(block) {

                block.pipe(gulpSrc())
                    .pipe(jsBuild);

                block.end('js/concat.js');

            }),

            // build css with preprocessor 
            css: htmlbuild.preprocess.css(function(block) {

                block.pipe(gulpSrc())
                    .pipe(cssBuild);

                block.end('css/concat.css');

            }),

            // remove blocks with this target 
            remove: function(block) {
                block.end();
            },

            // add a template with this target 
            template: function(block) {
                es.readArray([
                    '<!--',
                    '  processed by htmlbuild (' + block.args[0] + ')',
                    '-->'
                ].map(function(str) {
                    return block.indent + str;
                })).pipe(block);
            }
        }))
        .pipe(gulp.dest('src/build'));
});

gulp.task('less', function() {
    return gulp.src('src/' + projectBuild + '-app.less')
        .pipe(less({
            paths: [path.join(__dirname, 'less', 'includes')]
        }))
        //.pipe(cssmin())
        //.pipe(gulp.dest('src/build'))
        .pipe(rename({
            suffix: '_' + version,
            extname: ".css"
        }))
        .pipe(gulp.dest('src/build'))
});

gulp.task('material-css', function() {
    return gulp.src('src/lib/angular-material/angular-material.min.css')
        .pipe(gulp.dest('src/build/lib/angular-material/'));
});

gulp.task('html-files', function() {
    return gulp.src(['src/' + projectBuild + '/**/*.html'])
        .pipe(gulp.dest('src/build/' + projectBuild));
});

gulp.task('html-files-collect', function() {
    return gulp.src(['src/collect/**/*.html'])
        .pipe(gulp.dest('src/build/collect'));
});

gulp.task('html-files-publish', function() {
    return gulp.src(['src/publish/**/*.html'])
        .pipe(gulp.dest('src/build/publish'));
});

gulp.task('html-files-genesys', function() {
    return gulp.src(['src/genesys/**/*.html'])
        .pipe(gulp.dest('src/build/genesys'));
});

gulp.task('html-files-securities', function() {
    return gulp.src(['src/securities/**/*.html'])
        .pipe(gulp.dest('src/build/securities'));
});



gulp.task('html-files-main-dependencies', function() {
    return gulp.src(['src/main/**/*.html'])
        .pipe(gulp.dest('src/build/main'));
});

gulp.task('assets', function() {
    return gulp
        .src(['src/' + projectBuild + '/assets/**/*.jpg',
            'src/' + projectBuild + '/assets/**/*.png',
            'src/' + projectBuild + '/assets/**/*.gif'
        ])
        .pipe(gulp.dest('src/build/' + projectBuild + '/assets/'));
});

gulp.task('assets-main-dependencies', function() {
    return gulp
        .src(['src/main/assets/**/*.jpg',
            'src/main/assets/**/*.png',
            'src/mainassets/**/*.gif'
        ])
        .pipe(gulp.dest('src/build/main/assets/'));
});

gulp.task('favicon', function() {
    return gulp
        .src('src/' + projectBuild + '-favicon.png')
        .pipe(gulp.dest('src/build/'));
});

gulp.task('lib-fonts', function() {
    return gulp
        .src(['src/lib/**/*.ttf',
            'src/lib/**/*.woff',
            'src/lib/**/*.woff2'
        ])
        .pipe(gulp.dest('src/build/lib/'));
});

gulp.task('index-replace', function() {
    gulp.src(['src/build/' + projectBuild + '-index.html'])
        .pipe(replace('<script src="http://localhost:35729/livereload.js"></script>', ''))
        .pipe(replace('js/concat.js', 'js/concat_' + version + '.js'))
        .pipe(replace('app.less', 'app_' + version + '.css'))
        .pipe(replace('stylesheet/less', 'stylesheet'))
        .pipe(rename({
            basename: 'index',
            extname: ".html"
        }))
        .pipe(gulp.dest('src/build'));

    gulp.src('src/build/' + projectBuild + '-index.html')
        .pipe(clean({ force: true }));
});

gulp.task('pdf-viewer', function() {
    return gulp
        .src('src/pdf-viewer/**')
        .pipe(gulp.dest('src/build/pdf-viewer'));
});

gulp.task('rest', function() {
    return gulp
        .src(['backend/cf/**/*.cfm',
            'backend/cf/**/*.cfc',
            'backend/cf/**/*.bat',
            'backend/cf/**/*.xlsx',
        ])
        .pipe(gulp.dest('src/build/backend'));
});

gulp.task('clean', function() {
    return gulp.src('src/build')
        .pipe(clean({ force: true }));
});

// ———————————————————————————————————————————————————————————————————— 
//BUILDS
// ————————————————————————————————————————————————————————————————————

// NO IIS -> Deve remover o WEBDAV em MODULES para funcionar correntamente o REST

gulp.task('default', ['build-rest']);

gulp.task('build-rest', function() {
    projectBuild = 'main';
    gulpSequence('clean',
        'rest')();
});

gulp.task('build-main', function() {
    projectBuild = 'main';

    gulpSequence('clean', ['htmlbuild',
            'less',
            'material-css',
            'html-files',
            'html-files-collect',
            'html-files-publish',
            'html-files-securities',
            'html-files-genesys',
            'assets',
            'lib-fonts',
            'favicon',
            'pdf-viewer'
        ],
        'index-replace',
        'jshint-' + projectBuild)();
});

gulp.task('build-epaybox', function() {
    projectBuild = 'epaybox';
    gulpSequence('clean', ['htmlbuild',
            'less',
            'material-css',
            'html-files',
            'html-files-main-dependencies',
            'assets',
            'assets-main-dependencies',
            'lib-fonts',
            'favicon',
            'pdf-viewer'
        ],
        //'js-compress',
        //'js-concat',
        //'js-clean',
        'index-replace',
        'jshint-' + projectBuild)();
});

gulp.task('build-publish', function() {
    projectBuild = 'publish';
    gulpSequence('clean', ['htmlbuild',
            'less',
            'material-css',
            'html-files',
            'html-files-main-dependencies',
            'assets',
            'assets-main-dependencies',
            'lib-fonts',
            'favicon',
            'pdf-viewer'
        ],
        //'js-compress',
        //'js-concat',
        //'js-clean',
        'index-replace',
        'jshint-' + projectBuild)();
});

gulp.task('build-collect', function() {
    projectBuild = 'collect';
    gulpSequence('clean', ['htmlbuild',
            'less',
            'material-css',
            'html-files',
            'html-files-main-dependencies',
            'assets',
            'assets-main-dependencies',
            'lib-fonts',
            'favicon',
            'pdf-viewer'
        ],
        //'js-compress',
        //'js-concat',
        //'js-clean',
        'index-replace',
        'jshint-' + projectBuild)();
});