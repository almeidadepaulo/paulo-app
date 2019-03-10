(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('siclid-x-cosif', getState());
    }

    function getState() {
        return {
            url: '/siclid-x-cosif',
            templateUrl: 'contabil/partial/siclid-x-cosif/siclid-x-cosif.html',
            controller: 'SiclidXcosifCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                'id': null
            },
        };
    }
})();