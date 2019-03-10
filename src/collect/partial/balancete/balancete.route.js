(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('balancete', getState());
    }

    function getState() {
        return {
            url: '/balancete',
            templateUrl: 'collect/partial/balancete/balancete.html',
            controller: 'BalanceteCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                'id': null
            },
        };
    }
})();