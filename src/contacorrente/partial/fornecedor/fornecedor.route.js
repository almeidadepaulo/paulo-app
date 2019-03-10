(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('example', getState());
    }

    function getState() {
        return {
            url: '/example',
            templateUrl: 'main/partial/example/example.html',
            controller: 'ExampleCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                'id': null
            },
        };
    }
})();