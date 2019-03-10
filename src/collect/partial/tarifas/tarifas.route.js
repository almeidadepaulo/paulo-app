(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('tarifas', getState());
    }

    function getState() {
        return {
            url: '/tarifas',
            templateUrl: 'collect/partial/tarifas/tarifas.html',
            controller: 'TarifasCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                'id': null
            },
        };
    }
})();