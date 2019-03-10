(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('carteira-aberto', getState());
    }

    function getState() {
        return {
            url: '/carteira-aberto',
            templateUrl: 'collect/partial/carteira-aberto/carteira-aberto.html',
            controller: 'CarteiraAbertoCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                'id': null
            },
        };
    }
})();