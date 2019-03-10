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
            'flow',
            'ngFileUpload',
            'chart.js',
            'ng-currency',
            'smDateTimeRangePicker',
            'angularSoap',
            'ngQuill',
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
                    if (String(config.url).indexOf('seeaway-app') > -1 && localStorage.getItem('cedente')) {
                        config.headers['Cedente'] = localStorage.getItem('cedente');
                    } else {
                        delete config.headers['Authorization'];
                    }
                    return config;
                }
            };
        });

    angular.module(PROJECT_NAME).constant('config', {
        // RESTful - ColdFusion
        // Registrar REST: http://localhost:8500/seeaway-app/main/backend/cf/restInit.cfm
        REST_URL: window.location.origin + '/rest/seeaway-app',
        PROJECT_ID: 2,
        //GENESYS_URL: 'http://192.168.10.15:8080/genesys',
        GENESYS_URL: 'http://genesysadm-homol.seeaway.com.br/'
    });

    config.$inject = ['$stateProvider', '$urlRouterProvider', '$mdThemingProvider', '$mdDateLocaleProvider',
        'cfpLoadingBarProvider', '$httpProvider', 'flowFactoryProvider', 'pickerProvider', 'ngQuillConfigProvider'
    ];

    function config($stateProvider, $urlRouterProvider, $mdThemingProvider, $mdDateLocaleProvider,
        cfpLoadingBarProvider, $httpProvider, flowFactoryProvider, pickerProvider, ngQuillConfigProvider) {

        $httpProvider.interceptors.push('httpRequestInterceptor');

        $urlRouterProvider.otherwise(function($injector) {
            var $state = $injector.get('$state');
            $state.go('login');
        });

        $mdThemingProvider.definePalette('primaryPalette', {
            '50': 'e2e4e6',
            '100': 'b7bbc0',
            '200': '878e96',
            '300': '57606c',
            '400': '333e4d',
            '500': '0f1c2d',
            '600': '0d1928',
            '700': '0b1422',
            '800': '08111c',
            '900': '040911',
            'A100': '529cff',
            'A200': '1f7fff',
            'A400': '0065eb',
            'A700': '005ad2',
            'contrastDefaultColor': 'light',
            'contrastDarkColors': [
                '50',
                '100',
                '200',
                'A100'
            ],
            'contrastLightColors': [
                '300',
                '400',
                '500',
                '600',
                '700',
                '800',
                '900',
                'A200',
                'A400',
                'A700'
            ]
        });

        $mdThemingProvider.definePalette('accentPalette', {
            '50': 'f1f3f5',
            '100': 'dce0e5',
            '200': 'c5cbd4',
            '300': 'adb6c2',
            '400': '9ca7b5',
            '500': '8a97a8',
            '600': '828fa0',
            '700': '778497',
            '800': '6d7a8d',
            '900': '5a697d',
            'A100': 'e9f2ff',
            'A200': 'b6d4ff',
            'A400': '83b7ff',
            'A700': '69a8ff',
            'contrastDefaultColor': 'light',
            'contrastDarkColors': [
                '50',
                '100',
                '200',
                '300',
                '400',
                '500',
                '600',
                '700',
                'A100',
                'A200',
                'A400',
                'A700'
            ],
            'contrastLightColors': [
                '800',
                '900'
            ]
        });

        $mdThemingProvider.theme('default')
            .primaryPalette('primaryPalette')
            .accentPalette('accentPalette');

        $mdThemingProvider.definePalette('whitePalette', {
            '50': 'ffffff',
            '100': 'ffffff',
            '200': 'ffffff',
            '300': 'ffffff',
            '400': 'ffffff',
            '500': 'ffffff',
            '600': 'ffffff',
            '700': 'ffffff',
            '800': 'ffffff',
            '900': 'ffffff',
            'A100': 'ffffff',
            'A200': 'ffffff',
            'A400': 'ffffff',
            'A700': 'ffffff',
            'contrastDefaultColor': 'light',
            'contrastDarkColors': [
                '50',
                '100',
                '200',
                '300',
                '400',
                '500',
                '600',
                '700',
                '800',
                '900',
                'A100',
                'A200',
                'A400',
                'A700'
            ],
            'contrastLightColors': []
        });
        $mdThemingProvider.theme('whitePalette')
            .primaryPalette('whitePalette');

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

        flowFactoryProvider.defaults = {
            testChunks: false,
            permanentErrors: [404, 500, 501],
            maxChunkRetries: 1,
            chunkRetryInterval: 5000,
            simultaneousUploads: 4,
        };

        pickerProvider.setOkLabel('Ok');
        pickerProvider.setCancelLabel('Fechar');
        pickerProvider.setClearLabel('Apagar');
        pickerProvider.setCustomRangeLabel('Período');

        pickerProvider.setDayHeader('single'); //Options 'single','shortName', 'fullName' 
        pickerProvider.setDaysNames([
            { 'single': 'Dom', 'shortName': 'Domingo', 'fullName': 'Domingo' },
            { 'single': 'Seg', 'shortName': 'Segunda', 'fullName': 'Segunda-feira' },
            { 'single': 'Ter', 'shortName': 'Terça', 'fullName': 'Terça-feira' },
            { 'single': 'Qua', 'shortName': 'Quarta', 'fullName': 'Quarta-feira' },
            { 'single': 'Qui', 'shortName': 'Quinta', 'fullName': 'Quinta-feira' },
            { 'single': 'Sex', 'shortName': 'Sexta', 'fullName': 'Sexta-feira' },
            { 'single': 'Sab', 'shortName': 'Sabado', 'fullName': 'Sabado' }
        ]);
        pickerProvider.setDivider('Até');
        pickerProvider.setMonthNames(['Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio',
            'Junho', 'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'
        ]);
        pickerProvider.setRangeCustomStartEnd(['Inicial', 'Final']);
        pickerProvider.setRangeDefaultList([{
                label: 'Hoje',
                startDate: moment().utc().startOf('day'),
                endDate: moment().utc().endOf('day')
            },
            {
                label: 'Últimos 7 dias',
                startDate: moment().utc().subtract(7, 'd').startOf('day'),
                endDate: moment().utc().endOf('day')
            },
            {
                label: 'Este mês',
                startDate: moment().utc().startOf('month'),
                endDate: moment().utc().endOf('month')
            },
            {
                label: 'Último mês',
                startDate: moment().utc().subtract(1, 'month').startOf('month'),
                endDate: moment().utc().subtract(1, 'month').endOf('month')
            },
            {
                label: 'Este Ano',
                startDate: moment().utc().startOf('year'),
                endDate: moment().utc().endOf('year')
            }
        ]);

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
    }

    run.$inject = ['$rootScope', '$state', '$cookies', '$http', 'homeService', 'config', '$mdDialog'];

    function run($rootScope, $state, $cookies, $http, homeService, config, $mdDialog) {

        // keep user logged in after page refresh
        //$rootScope.globals = $cookies.getObject('globals') || {};
        if (sessionStorage.getItem('globals')) {
            //console.info('sessionStorage', JSON.parse(sessionStorage.getItem('globals')));
            $rootScope.globals = JSON.parse(sessionStorage.getItem('globals'));
        } else {
            $rootScope.globals = {};
        }

        $rootScope.$on('$stateChangeStart', function(event, toState, toParams) {
            if (toState.name === 'login' || toState.name.search('register') > -1) {
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
                            if ($rootScope.globals.currentUser.perfilTipo === 1) {
                                $state.go('menu');
                            }
                        }, function error(response) {
                            console.error(response);
                        });

                    //event.preventDefault();
                } else if ($rootScope.globals.currentUser.perfilTipo === 2 &&
                    JSON.parse(localStorage.getItem('cedente')).form && toState.name !== 'cedente-form') { // backoffice
                    $mdDialog.show(
                        $mdDialog.alert()
                        .clickOutsideToClose(false)
                        .title('Aviso')
                        .textContent('Olá ' + $rootScope.globals.currentUser.nome + ', para acessar as funções do backoffice, cadastre ao menos um cedente.')
                        .ariaLabel('Aviso')
                        .ok('Ok')
                    );
                    $state.go('cedente-form');
                    event.preventDefault();
                } else if (toState.name !== 'menu' &&
                    toState.name !== 'cedente-form' &&
                    ($rootScope.globals.currentUser.perfilTipo === 2 || $rootScope.globals.currentUser.perfilTipo === 3) &&
                    JSON.parse(localStorage.getItem('cedente')) &&
                    JSON.parse(localStorage.getItem('cedente')).CEDENTE_ID === 0) {
                    $mdDialog.show(
                        $mdDialog.alert()
                        .clickOutsideToClose(false)
                        .title('Atenção')
                        .textContent('Selecione ou digite um cedente para acessar as funções do backoffice!')
                        .ariaLabel('Aviso')
                        .ok('Ok')
                    );
                    $state.go('menu');
                    event.preventDefault();
                }
            }
        });
    }
})();