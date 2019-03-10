(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('sms-upload', getState());
    }

    function getState() {
        return {
            url: '/sms-upload',
            templateUrl: 'publish/partial/sms-upload/sms-upload.html',
            controller: 'SmsUploadCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                'id': null
            },
        };
    }
})();