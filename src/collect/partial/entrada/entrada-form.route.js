(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('entrada-form', getState());
    }

    function getState() {
        return {
            url: '/entrada-form/',
            templateUrl: 'collect/partial/entrada/entrada-form.html',
            controller: 'EntradaFormCtrl',
            controllerAs: 'vm',
            parent: 'home'
        };
    }
})();