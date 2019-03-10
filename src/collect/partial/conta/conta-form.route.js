(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('conta-form', getState());
    }

    function getState() {
        return {
            url: '/conta-form/:CB260_NR_OPERADOR/:CB260_NR_CEDENTE/:CB260_CD_COMPSC/:CB260_NR_AGENC/:CB260_NR_CONTA/:CB260_CD_CART',
            templateUrl: 'collect/partial/conta/conta-form.html',
            controller: 'ContaFormCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                CB260_NR_OPERADOR: null,
                CB260_NR_CEDENTE: null,
                CB260_CD_COMPSC: null,
                CB260_NR_AGENC: null,
                CB260_NR_CONTA: null,
                CB260_CD_CART: null
            },
            resolve: {
                getData: getData
            }
        };
    }

    getData.$inject = ['$state', '$stateParams', 'contaService'];

    function getData($state, $stateParams, contaService) {
        // Verificar pk
        if ($stateParams.CB260_NR_OPERADOR &&
            $stateParams.CB260_NR_CEDENTE &&
            $stateParams.CB260_CD_COMPSC &&
            $stateParams.CB260_NR_AGENC &&
            $stateParams.CB260_NR_CONTA &&
            $stateParams.CB260_CD_CART) {
            $stateParams.id = $stateParams;
            return contaService.getById($stateParams.id).then(success).catch(error);
        } else {
            return {};
        }

        function success(response) {
            console.info(response);
            return response.query[0];
        }

        function error(response) {
            console.error(response);
            return response;
        }
    }
})();