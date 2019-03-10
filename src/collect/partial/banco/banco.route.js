(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('banco', getState());
    }

    function getState() {
        return {
            url: '/banco',
            templateUrl: 'collect/partial/banco/banco.html',
            controller: 'BancoCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                'id': null
            },
        };
    }
})();