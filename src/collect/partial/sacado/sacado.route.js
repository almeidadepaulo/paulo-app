(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('sacado', getState());
    }

    function getState() {
        return {
            url: '/sacado',
            templateUrl: 'collect/partial/sacado/sacado.html',
            controller: 'SacadoCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                'id': null
            },
        };
    }
})();