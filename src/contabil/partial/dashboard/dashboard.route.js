(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('dashboard', getState());
    }

    function getState() {
        return {
            url: '/dashboard',
            templateUrl: 'contabil/partial/dashboard/dashboard.html',
            controller: 'DashboardCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                'id': null
            },
        };
    }
})();