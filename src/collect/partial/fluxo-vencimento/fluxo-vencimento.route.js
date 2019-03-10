(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('fluxo-vencimento', getState());
    }

    function getState() {
        return {
            url: '/fluxo-vencimento',
            templateUrl: 'collect/partial/fluxo-vencimento/fluxo-vencimento.html',
            controller: 'FluxoVencimentoCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                'id': null
            },
        };
    }
})();