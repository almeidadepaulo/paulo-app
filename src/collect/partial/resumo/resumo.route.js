(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('resumo', getState());
    }

    function getState() {
        return {
            url: '/resumo',
            templateUrl: 'collect/partial/resumo/resumo.html',
            controller: 'ResumoCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                'id': null
            },
        };
    }
})();