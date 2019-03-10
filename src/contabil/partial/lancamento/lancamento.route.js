(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('lancamento', getState());
    }

    function getState() {
        return {
            url: '/lancamento',
            templateUrl: 'contabil/partial/lancamento/lancamento.html',
            controller: 'LancamentoCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                id: null,
                selectedItems: null
            },
        };
    }
})();