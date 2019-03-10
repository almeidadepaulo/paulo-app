(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('carteira', getState());
    }

    function getState() {
        return {
            url: '/carteira',
            templateUrl: 'collect/partial/carteira/carteira.html',
            controller: 'CarteiraCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                'id': null
            },
        };
    }
})();