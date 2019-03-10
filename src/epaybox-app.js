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
            'ui.utils.masks',
            'ui.mask',
            'angular-loading-bar',
            'pxConfig',
            'px-string-util',
            'px-data-grid',
            'chart.js',
            'ngSanitize',
            'materialCalendar'
        ])
        .constant('appConfig', {
            'nodeUrl': 'http://'
        })
        .config(config)
        .run(run);

    angular.module(PROJECT_NAME).constant('config', {
        // RESTful - ColdFusion
        // Registrar REST: http://localhost:8500/seeaway-app/main/rest/cf/restInit.cfm
        'REST_URL': window.location.origin + '/rest/seeaway-app'
    });

    config.$inject = ['$stateProvider', '$urlRouterProvider', '$mdThemingProvider', '$mdDateLocaleProvider',
        'cfpLoadingBarProvider'
    ];

    function config($stateProvider, $urlRouterProvider, $mdThemingProvider, $mdDateLocaleProvider,
        cfpLoadingBarProvider) {

        $urlRouterProvider.otherwise(function($injector) {
            var $state = $injector.get('$state');
            $state.go('login');
        });

        $mdThemingProvider.theme('default')
            .primaryPalette('grey')
            .accentPalette('blue');

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
            if (moment(date).format('L') === 'Invalid date') {
                return '';
            } else {
                return moment(date).format('L');
            }
        };

        cfpLoadingBarProvider.includeSpinner = false;
    }

    run.$inject = ['$rootScope', '$state', '$cookies', '$http'];

    function run($rootScope, $state, $cookies, $http) {

        // keep user logged in after page refresh
        $rootScope.globals = $cookies.getObject('globals') || {};
        if ($rootScope.globals.currentUser) {
            $http.defaults.headers.common['Authorization'] = 'Basic ' + $rootScope.globals.currentUser.authdata; // jshint ignore:line
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
                    $state.go('dashboard');
                    event.preventDefault();
                }
            }
        });
    }
})();