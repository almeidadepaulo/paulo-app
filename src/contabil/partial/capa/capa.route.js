(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('capa', getState());
    }

    function getState() {
        return {
            url: '/capa',
            templateUrl: 'contabil/partial/capa/capa.html',
            controller: 'CapaCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                'id': null
            },
        };
    }
})();