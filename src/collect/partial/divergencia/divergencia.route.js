(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('divergencia', getState());
    }

    function getState() {
        return {
            url: '/divergencia',
            templateUrl: 'collect/partial/divergencia/divergencia.html',
            controller: 'DivergenciaCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                'id': null
            },
        };
    }
})();