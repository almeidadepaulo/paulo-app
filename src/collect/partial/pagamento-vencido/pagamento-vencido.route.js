(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('pagamento-vencido', getState());
    }

    function getState() {
        return {
            url: '/pagamento-vencido',
            templateUrl: 'collect/partial/pagamento-vencido/pagamento-vencido.html',
            controller: 'PagamentoVencidoCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                'id': null
            },
        };
    }
})();