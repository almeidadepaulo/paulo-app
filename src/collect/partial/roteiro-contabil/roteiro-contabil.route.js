(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('roteiro-contabil', getState());
    }

    function getState() {
        return {
            url: '/roteiro-contabil',
            templateUrl: 'collect/partial/roteiro-contabil/roteiro-contabil.html',
            controller: 'RoteiroContabilCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                'id': null
            },
        };
    }
})();