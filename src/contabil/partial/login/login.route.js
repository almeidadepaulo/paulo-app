(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider', 'config'];
    /* @ngInject */
    function configure($stateProvider, config) {
        $stateProvider.state('login', getState(config));
    }

    function getState(config) {
        return {
            url: '/login/:action',
            controller: 'LoginCtrl',
            controllerAs: 'vm',
            templateUrl: 'contabil/partial/login/login.html',
            title: 'login'
        };
    }
})();