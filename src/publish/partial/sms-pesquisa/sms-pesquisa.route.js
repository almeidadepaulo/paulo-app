(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('sms-pesquisa', getState());
    }

    function getState() {
        return {
            url: '/sms-pesquisa',
            templateUrl: 'publish/partial/sms-pesquisa/sms-pesquisa.html',
            controller: 'SmsPesquisaCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                'id': null
            },
        };
    }
})();