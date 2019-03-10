(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('sms-codigo', getState());
    }

    function getState() {
        return {
            url: '/sms-codigo',
            templateUrl: 'publish/partial/sms-codigo/sms-codigo.html',
            controller: 'SmsCodigoCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                'id': null
            },
        };
    }
})();