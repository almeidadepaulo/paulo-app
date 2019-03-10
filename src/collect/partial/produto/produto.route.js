(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('produto', getState());
    }

    function getState() {
        return {
            url: '/produto',
            templateUrl: 'collect/partial/produto/produto.html',
            controller: 'ProdutoCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                'id': null
            },
        };
    }
})();