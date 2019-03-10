(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('carteira-aberto-form', getState());
    }

    function getState() {
        return {
            url: '/carteira-aberto-form/:CB210_NR_OPERADOR/:CB210_NR_CEDENTE/:CB210_CD_COMPSC/:CB210_NR_AGENC/:CB210_NR_CONTA/:CB210_NR_NOSNUM/:CB210_NR_CPFCNPJ/:CB210_NR_PROTOC',
            templateUrl: 'collect/partial/carteira-aberto/carteira-aberto-form.html',
            controller: 'CarteiraAbertoFormCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                CB210_NR_OPERADOR: null,
                CB210_NR_CEDENTE: null,
                CB210_CD_COMPSC: null,
                CB210_NR_AGENC: null,
                CB210_NR_CONTA: null,
                CB210_NR_NOSNUM: null,
                CB210_NR_CPFCNPJ: null,
                CB210_NR_PROTOC: null
            },
            resolve: {
                getData: getData
            }
        };
    }

    getData.$inject = ['$state', '$stateParams', 'pagamentoService'];

    function getData($state, $stateParams, pagamentoService) {
        // Verificar pk
        if ($stateParams.CB210_NR_OPERADOR &&
            $stateParams.CB210_NR_CEDENTE &&
            $stateParams.CB210_CD_COMPSC &&
            $stateParams.CB210_NR_AGENC &&
            $stateParams.CB210_NR_CONTA &&
            $stateParams.CB210_NR_NOSNUM &&
            $stateParams.CB210_NR_CPFCNPJ &&
            $stateParams.CB210_NR_PROTOC) {

            $stateParams.id = $stateParams;
            return pagamentoService.getById($stateParams.id).then(success).catch(error);
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