(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('pagamento', getState());
    }

    function getState() {
        return {
            url: '/pagamento',
            templateUrl: 'collect/partial/pagamento/pagamento.html',
            controller: 'PagamentoCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                'id': null
            },
        };
    }
})();