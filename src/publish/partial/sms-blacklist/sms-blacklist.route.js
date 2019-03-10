(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('sms-blacklist', getState());
    }

    function getState() {
        return {
            url: '/sms-blacklist',
            templateUrl: 'publish/partial/sms-blacklist/sms-blacklist.html',
            controller: 'SmsBlacklistCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                'id': null
            },
        };
    }
})();