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
            templateUrl: 'epaybox/partial/2via/2via.html',
            controller: 'SegundaViaCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                id: null
            },
        };
    }
})();