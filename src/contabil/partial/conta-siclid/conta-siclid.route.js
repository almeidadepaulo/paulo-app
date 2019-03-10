(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('conta-siclid', getState());
    }

    function getState() {
        return {
            url: '/conta-siclid',
            templateUrl: 'contabil/partial/conta-siclid/conta-siclid.html',
            controller: 'ContaSiclidCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                'id': null
            },
        };
    }
})();