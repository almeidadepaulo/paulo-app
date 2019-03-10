(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('conciliador-ocorrencia', getState());
    }

    function getState() {
        return {
            url: '/conciliador-ocorrencia',
            templateUrl: 'contabil/partial/conciliador-ocorrencia/conciliador-ocorrencia.html',
            controller: 'ConciliadorOcorrenciaCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                'id': null
            },
        };
    }
})();