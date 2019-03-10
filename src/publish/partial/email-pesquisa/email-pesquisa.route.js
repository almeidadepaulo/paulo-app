(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('email-pesquisa', getState());
    }

    function getState() {
        return {
            url: '/email-pesquisa',
            templateUrl: 'publish/partial/email-pesquisa/email-pesquisa.html',
            controller: 'EmailPesquisaCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                'id': null
            },
        };
    }
})();