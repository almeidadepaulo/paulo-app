(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('email-form', getState());
    }

    function getState() {
        return {
            url: '/email',
            templateUrl: 'collect/partial/email/email-form.html',
            controller: 'EmailFormCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                'id': null
            },
        };
    }
})();