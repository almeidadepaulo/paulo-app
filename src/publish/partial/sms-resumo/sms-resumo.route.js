(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('sms-resumo', getState());
    }

    function getState() {
        return {
            url: '/sms-resumo',
            templateUrl: 'publish/partial/sms-resumo/sms-resumo.html',
            controller: 'SmsResumoCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                'id': null
            },
        };
    }
})();