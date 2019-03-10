(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('sms-mensagem', getState());
    }

    function getState() {
        return {
            url: '/sms-mensagem',
            templateUrl: 'publish/partial/sms-mensagem/sms-mensagem.html',
            controller: 'SmsMensagemCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                'id': null
            },
        };
    }
})();