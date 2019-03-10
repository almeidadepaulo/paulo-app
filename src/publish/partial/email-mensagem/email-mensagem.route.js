(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('email-mensagem', getState());
    }

    function getState() {
        return {
            url: '/email-mensagem',
            templateUrl: 'publish/partial/email-mensagem/email-mensagem.html',
            controller: 'EmailMensagemCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                'id': null
            },
        };
    }
})();