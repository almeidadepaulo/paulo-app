(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('ph3', getState());
    }

    function getState() {
        return {
            url: '/ph3a',
            templateUrl: 'main/partial/ph3a/ph3a.html',
            controller: 'Ph3aCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                'id': null
            },
        };
    }
})();