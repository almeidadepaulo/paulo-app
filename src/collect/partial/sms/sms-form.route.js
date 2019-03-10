(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('sms-form', getState());
    }

    function getState() {
        return {
            url: '/sms-form/',
            templateUrl: 'collect/partial/sms/sms-form.html',
            controller: 'SmsFormCtrl',
            controllerAs: 'vm',
            parent: 'home'
        };
    }
})();