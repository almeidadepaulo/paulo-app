(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('cedente', getState());
    }

    function getState() {
        return {
            url: '/cedente',
            templateUrl: 'main/partial/cedente/cedente.html',
            controller: 'CedenteCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                'id': null
            },
        };
    }
})();