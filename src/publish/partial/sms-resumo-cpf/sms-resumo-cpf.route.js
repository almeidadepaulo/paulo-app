(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('sms-resumo-cpf', getState());
    }

    function getState() {
        return {
            url: '/sms-resumo-cpf',
            templateUrl: 'publish/partial/sms-resumo-cpf/sms-resumo-cpf.html',
            controller: 'SmsResumoCpfCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                'id': null
            },
        };
    }
})();