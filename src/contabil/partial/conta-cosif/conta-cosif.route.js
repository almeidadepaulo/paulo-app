(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('conta-cosif', getState());
    }

    function getState() {
        return {
            url: '/conta-cosif',
            templateUrl: 'contabil/partial/conta-cosif/conta-cosif.html',
            controller: 'ContaCosifCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                'id': null
            },
        };
    }
})();