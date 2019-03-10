(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('titulo-vencido', getState());
    }

    function getState() {
        return {
            url: '/titulo-vencido',
            templateUrl: 'collect/partial/titulo-vencido/titulo-vencido.html',
            controller: 'TituloVencidoCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                'id': null
            },
        };
    }
})();