(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('email-blacklist', getState());
    }

    function getState() {
        return {
            url: '/email-blacklist',
            templateUrl: 'publish/partial/email-blacklist/email-blacklist.html',
            controller: 'EmailBlacklistCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                'id': null
            },
        };
    }
})();