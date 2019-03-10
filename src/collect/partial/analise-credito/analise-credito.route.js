(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('analise-credito', getState());
    }

    function getState() {
        return {
            url: '/analise-credito/',
            templateUrl: 'collect/partial/analise-credito/analise-credito.html',
            controller: 'AnaliseCreditoCtrl',
            controllerAs: 'vm',
            parent: 'home'
        };
    }
})();