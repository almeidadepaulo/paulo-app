(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('2via', getState());
    }

    function getState() {
        return {
            url: '/2via',
            templateUrl: 'collect/partial/2via/2via.html',
            controller: 'SegundaviaCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                'id': null
            },
        };
    }
})();