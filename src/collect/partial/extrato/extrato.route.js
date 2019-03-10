(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('extrato', getState());
    }

    function getState() {
        return {
            url: '/extrato',
            templateUrl: 'collect/partial/extrato/extrato.html',
            controller: 'ExtratoCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                'id': null
            },
        };
    }
})();