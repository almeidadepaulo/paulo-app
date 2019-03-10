(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('entrada-relatorio', getState());
    }

    function getState() {
        return {
            url: '/entrada-relatorio',
            templateUrl: 'collect/partial/entrada-relatorio/entrada-relatorio.html',
            controller: 'EntradaRelatorioCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                'id': null
            },
        };
    }
})();