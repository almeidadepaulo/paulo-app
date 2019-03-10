(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('sms-pacote', getState());
    }

    function getState() {
        return {
            url: '/sms-pacote',
            templateUrl: 'publish/partial/sms-pacote/sms-pacote.html',
            controller: 'SmsPacoteCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                'id': null
            },
        };
    }
})();