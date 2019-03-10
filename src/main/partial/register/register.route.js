(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider', '$urlRouterProvider'];
    /* @ngInject */
    function configure($stateProvider, $urlRouterProvider) {

        $stateProvider.state('register', {
            url: '/register',
            controller: 'RegisterCtrl',
            controllerAs: 'vm',
            templateUrl: 'main/partial/register/register.html'
        })

        .state('register.profile', {
            url: '/profile',
            templateUrl: 'main/partial/register/form-profile.html'
        })

        .state('register.info', {
            url: '/info',
            templateUrl: 'main/partial/register/form-info.html'
        })

        .state('register.address', {
            url: '/address',
            templateUrl: 'main/partial/register/form-address.html'
        })

        .state('register.doc', {
            url: '/doc',
            templateUrl: 'main/partial/register/form-doc.html'
        });

        //$urlRouterProvider.otherwise('/register/profile');
    }
})();