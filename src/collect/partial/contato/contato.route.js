(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('contato', getState());
    }

    function getState() {
        return {
            url: '/contato',
            templateUrl: 'collect/partial/contato/contato.html',
            controller: 'ContatoCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                'id': null
            },
        };
    }
})();