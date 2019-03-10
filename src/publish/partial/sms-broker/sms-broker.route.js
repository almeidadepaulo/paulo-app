(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('sms-broker', getState());
    }

    function getState() {
        return {
            url: '/sms-broker',
            templateUrl: 'publish/partial/sms-broker/sms-broker.html',
            controller: 'SmsBrokerCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                'id': null
            },
        };
    }
})();