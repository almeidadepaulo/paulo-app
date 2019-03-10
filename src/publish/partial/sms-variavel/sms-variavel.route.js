(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('sms-variavel', getState());
    }

    function getState() {
        return {
            url: '/sms-variavel',
            templateUrl: 'publish/partial/sms-variavel/sms-variavel.html',
            controller: 'SmsVariavelCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                'id': null
            },
        };
    }
})();