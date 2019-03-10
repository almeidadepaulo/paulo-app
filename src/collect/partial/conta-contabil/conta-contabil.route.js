(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('conta-contabil', getState());
    }

    function getState() {
        return {
            url: '/conta-contabil',
            templateUrl: 'collect/partial/conta-contabil/conta-contabil.html',
            controller: 'ContaContabilCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                'id': null
            },
        };
    }
})();