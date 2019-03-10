(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('arquivo-processamento', getState());
    }

    function getState() {
        return {
            url: '/arquivo-processamento',
            templateUrl: 'collect/partial/arquivo-processamento/arquivo-processamento.html',
            controller: 'ArquivoProcessamentoCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                'id': null
            },
        };
    }
})();