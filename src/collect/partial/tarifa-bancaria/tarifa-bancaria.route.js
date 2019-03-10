(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('tarifa-bancaria', getState());
    }

    function getState() {
        return {
            url: '/tarifa-bancaria',
            templateUrl: 'collect/partial/tarifa-bancaria/tarifa-bancaria.html',
            controller: 'TarifaBancariaCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                'id': null
            },
        };
    }
})();