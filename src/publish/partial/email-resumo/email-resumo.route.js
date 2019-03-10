(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('email-resumo', getState());
    }

    function getState() {
        return {
            url: '/email-resumo',
            templateUrl: 'publish/partial/email-resumo/email-resumo.html',
            controller: 'EmailResumoCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                'id': null
            },
        };
    }
})();