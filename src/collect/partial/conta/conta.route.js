(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('conta', getState());
    }

    function getState() {
        return {
            url: '/conta',
            templateUrl: 'collect/partial/conta/conta.html',
            controller: 'ContaCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                'id': null
            },
        };
    }
})();