(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('pagamento-antecipado', getState());
    }

    function getState() {
        return {
            url: '/pagamento-antecipado',
            templateUrl: 'collect/partial/pagamento-antecipado/pagamento-antecipado.html',
            controller: 'PagamentoAntecipadoCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                'id': null
            },
        };
    }
})();