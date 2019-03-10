(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('contrato', getState());
    }

    function getState() {
        return {
            url: '/contrato',
            templateUrl: 'collect/partial/contrato/contrato.html',
            controller: 'ContratoCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                'id': null
            },
        };
    }
})();