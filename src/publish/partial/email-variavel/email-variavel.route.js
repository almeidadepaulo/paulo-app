(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('email-variavel', getState());
    }

    function getState() {
        return {
            url: '/email-variavel',
            templateUrl: 'publish/partial/email-variavel/email-variavel.html',
            controller: 'EmailVariavelCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                'id': null
            },
        };
    }
})();