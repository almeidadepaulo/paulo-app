(function() {
    'use strict';

    const PROJECT_NAME = 'seeawayApp';

    angular
        .module(PROJECT_NAME, [
            'ui.router',
            'ngCookies',
            'ngMaterial',
            'ngMessages',
            'ngResource',
            'ngSanitize',
            'ui.utils.masks',
            'idf.br-filters',
            'ui.mask',
            'angular-loading-bar',
            'pxConfig',
            'px-string-util',
            'px-data-grid',
            'md.data.table',
            'ngQuill',
            'flow',
            'chart.js',
            'ng-currency'
        ])
        .constant('appConfig', {
            'nodeUrl': 'http://'
        })
        .config(config)
        .run(run);

    angular
        .module(PROJECT_NAME)
        .factory('httpRequestInterceptor', function() {
            return {
                request: function(config) {
                    //console.info('httpRequestInterceptor', localStorage.getItem('cedente'));
                    //config.headers['Authorization'] = '';
                    //config.headers['Accept'] = 'application/json;odata=verbose';
                    if (localStorage.getItem('cedente')) {
                        config.headers['Cedente'] = localStorage.getItem('cedente');
                    }
                    return config;
                }
            };
        });

    angular.module(PROJECT_NAME).constant('config', {
        // RESTful - ColdFusion
        // Registrar REST: http://localhost:8500/seeaway-app/main/backend/cf/restInit.cfm
        REST_URL: window.location.origin + '/rest/seeaway-app',
        PROJECT_ID: 1
    });

    config.$inject = ['$stateProvider', '$urlRouterProvider', '$mdThemingProvider', '$mdDateLocaleProvider',
        'cfpLoadingBarProvider', '$httpProvider', 'ngQuillConfigProvider', 'flowFactoryProvider'
    ];

    function config($stateProvider, $urlRouterProvider, $mdThemingProvider, $mdDateLocaleProvider,
        cfpLoadingBarProvider, $httpProvider, ngQuillConfigProvider, flowFactoryProvider) {

        $httpProvider.interceptors.push('httpRequestInterceptor');

        $urlRouterProvider.otherwise(function($injector) {
            var $state = $injector.get('$state');
            $state.go('login');
        });

        $mdThemingProvider.theme('default')
            .primaryPalette('grey')
            .accentPalette('red');

        moment.locale('pt-BR');
        numeral.language('pt-br');

        // https://material.angularjs.org/latest/api/service/$mdDateLocaleProvider
        $mdDateLocaleProvider.months = ['janeiro',
            'fevereiro',
            'março',
            'abril',
            'maio',
            'junho',
            'julho',
            'agosto',
            'setembro',
            'outubro',
            'novembro',
            'dezembro'
        ];
        $mdDateLocaleProvider.shortMonths = ['jan.',
            'fev',
            'mar',
            'abr',
            'maio',
            'jun',
            'jul',
            'ago',
            'set',
            'out',
            'nov',
            'dez'
        ];
        $mdDateLocaleProvider.parseDate = function(dateString) {
            var m = moment(dateString, 'L', true);
            return m.isValid() ? m.toDate() : new Date(NaN);
        };

        $mdDateLocaleProvider.formatDate = function(date) {
            var m = moment(date);
            return m.isValid() ? m.format('L') : '';
        };

        cfpLoadingBarProvider.includeSpinner = false;

        ngQuillConfigProvider.set([{
            alias: '10',
            size: '10px'
        }, {
            alias: '12',
            size: '12px'
        }, {
            alias: '14',
            size: '14px'
        }, {
            alias: '16',
            size: '16px'
        }, {
            alias: '18',
            size: '18px'
        }, {
            alias: '20',
            size: '20px'
        }, {
            alias: '22',
            size: '22px'
        }, {
            alias: '24',
            size: '24px'
        }], [{
            label: 'Arial',
            alias: 'Arial'
        }, {
            label: 'Sans Serif',
            alias: 'sans-serif'
        }, {
            label: 'Serif',
            alias: 'serif'
        }, {
            label: 'Monospace',
            alias: 'monospace'
        }, {
            label: 'Trebuchet MS',
            alias: '"Trebuchet MS"'
        }, {
            label: 'Verdana',
            alias: 'Verdana'
        }]);

        flowFactoryProvider.defaults = {
            testChunks: false,
            permanentErrors: [404, 500, 501],
            maxChunkRetries: 1,
            chunkRetryInterval: 5000,
            simultaneousUploads: 4,
        };
    }

    run.$inject = ['$rootScope', '$state', '$cookies', '$http', 'homeService', 'config'];

    function run($rootScope, $state, $cookies, $http, homeService, config) {

        // keep user logged in after page refresh
        //$rootScope.globals = $cookies.getObject('globals') || {};
        if (sessionStorage.getItem('globals')) {
            //console.info('sessionStorage', JSON.parse(sessionStorage.getItem('globals')));
            $rootScope.globals = JSON.parse(sessionStorage.getItem('globals'));
        } else {
            $rootScope.globals = {};
        }

        $rootScope.$on('$stateChangeStart', function(event, toState, toParams) {
            if (toState.name === 'login' || toState.name === 'register') {
                return;
            } else {
                var loggedIn = $rootScope.globals.currentUser;
                if (!loggedIn) {
                    $state.go('login');
                    event.preventDefault();
                } else if (toState.name === 'home') {
                    // Redirecionar para primeira tela                    
                    homeService.getMenu()
                        .then(function success(response) {
                            localStorage.setItem('menu' + config.PROJECT_ID, JSON.stringify(response.query));
                            localStorage.setItem('menuId' + config.PROJECT_ID, response.query[0].MEN_ID);
                            localStorage.setItem('menuIndex' + config.PROJECT_ID, -1);
                            $state.go('menu');
                        }, function error(response) {
                            console.error(response);
                        });

                    event.preventDefault();
                }
            }
        });
    }
})();