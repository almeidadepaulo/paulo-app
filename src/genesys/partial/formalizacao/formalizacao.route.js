(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('formalizacao', getState());
    }

    function getState() {
        return {
            url: '/formalizacao',
            templateUrl: 'genesys/partial/formalizacao/formalizacao.html',
            controller: 'FormalizacaoCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                'id': null
            },
        };
    }
})();