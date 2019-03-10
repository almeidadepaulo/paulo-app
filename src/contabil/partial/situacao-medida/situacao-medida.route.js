(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('situacao-medida', getState());
    }

    function getState() {
        return {
            url: '/situacao-medida',
            templateUrl: 'contabil/partial/situacao-medida/situacao-medida.html',
            controller: 'SituacaoMedidaCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                'id': null
            },
        };
    }
})();