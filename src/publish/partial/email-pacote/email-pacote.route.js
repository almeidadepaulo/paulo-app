(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('email-pacote', getState());
    }

    function getState() {
        return {
            url: '/email-pacote',
            templateUrl: 'publish/partial/email-pacote/email-pacote.html',
            controller: 'EmailPacoteCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                'id': null
            },
        };
    }
})();