(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('email-broker', getState());
    }

    function getState() {
        return {
            url: '/email-broker',
            templateUrl: 'publish/partial/email-broker/email-broker.html',
            controller: 'EmailBrokerCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                'id': null
            },
        };
    }
})();