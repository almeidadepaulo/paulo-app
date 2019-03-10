(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('agencia', getState());
    }

    function getState() {
        return {
            url: '/agencia',
            templateUrl: 'collect/partial/agencia/agencia.html',
            controller: 'AgenciaCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                'id': null
            },
        };
    }
})();