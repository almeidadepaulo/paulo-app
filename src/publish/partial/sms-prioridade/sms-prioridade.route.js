(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('sms-prioridade', getState());
    }

    function getState() {
        return {
            url: '/sms-prioridade',
            templateUrl: 'publish/partial/sms-prioridade/sms-prioridade.html',
            controller: 'SmsPrioridadeCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                'id': null
            },
        };
    }
})();