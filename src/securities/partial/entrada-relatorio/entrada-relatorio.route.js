(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('entrada-relatorio-sec', getState());
    }

    function getState() {
        return {
            url: '/entrada-relatorio-sec',
            templateUrl: 'securities/partial/entrada-relatorio/entrada-relatorio.html',
            controller: 'EntradaRelatorioCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                'id': null
            },
        };
    }
})();