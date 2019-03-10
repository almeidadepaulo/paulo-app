(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('cessionario', getState());
    }

    function getState() {
        return {
            url: '/cessionario',
            templateUrl: 'securities/partial/cessionario/cessionario.html',
            controller: 'CessionarioCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                'id': null
            },
        };
    }
})();