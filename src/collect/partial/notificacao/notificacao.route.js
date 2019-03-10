(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('notificacao', getState());
    }

    function getState() {
        return {
            url: '/notificacao',
            templateUrl: 'collect/partial/notificacao/notificacao.html',
            controller: 'NotificacaoCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                'id': null
            },
        };
    }
})();