(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('ocorrencia', getState());
    }

    function getState() {
        return {
            url: '/ocorrencia',
            templateUrl: 'contabil/partial/ocorrencia/ocorrencia.html',
            controller: 'OcorrenciaCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                'id': null
            },
        };
    }
})();