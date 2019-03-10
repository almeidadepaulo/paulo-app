(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('carteira-selecao', getState());
    }

    function getState() {
        return {
            url: '/carteira-selecao',
            templateUrl: 'securities/partial/carteira-selecao/carteira-selecao.html',
            controller: 'CarteiraSelecaoCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                'id': null
            },
        };
    }
})();