(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('pagamento-relatorio', getState());
    }

    function getState() {
        return {
            url: '/pagamento-relatorio',
            templateUrl: 'collect/partial/pagamento-relatorio/pagamento-relatorio.html',
            controller: 'PagamentoRelatorioCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                'id': null
            },
        };
    }
})();