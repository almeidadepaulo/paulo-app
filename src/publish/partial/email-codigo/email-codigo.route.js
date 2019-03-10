(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('email-codigo', getState());
    }

    function getState() {
        return {
            url: '/email-codigo',
            templateUrl: 'publish/partial/email-codigo/email-codigo.html',
            controller: 'EmailCodigoCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                'id': null
            },
        };
    }
})();