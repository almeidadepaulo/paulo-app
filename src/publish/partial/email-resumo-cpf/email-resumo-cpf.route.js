(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('email-resumo-cpf', getState());
    }

    function getState() {
        return {
            url: '/email-resumo-cpf',
            templateUrl: 'publish/partial/email-resumo-cpf/email-resumo-cpf.html',
            controller: 'EmailResumoCpfCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                'id': null
            },
        };
    }
})();