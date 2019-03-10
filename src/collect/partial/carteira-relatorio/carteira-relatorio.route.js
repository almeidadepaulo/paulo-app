(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('carteira-relatorio', getState());
    }

    function getState() {
        return {
            url: '/carteira-relatorio',
            templateUrl: 'collect/partial/carteira-relatorio/carteira-relatorio.html',
            controller: 'CarteiraRelatorioCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                'id': null
            },
        };
    }
})();