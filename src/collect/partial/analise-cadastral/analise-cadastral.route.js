(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('analise-cadastral', getState());
    }

    function getState() {
        return {
            url: '/analise-cadastral/',
            templateUrl: 'collect/partial/analise-cadastral/analise-cadastral.html',
            controller: 'AnaliseCadastralCtrl',
            controllerAs: 'vm',
            parent: 'home'
        };
    }
})();