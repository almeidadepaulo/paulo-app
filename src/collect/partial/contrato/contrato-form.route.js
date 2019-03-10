(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('contrato-form', getState());
    }

    function getState() {
        return {
            url: '/contrato-form/:CB213_NR_OPERADOR/:CB213_NR_CEDENTE/:CB213_NR_CONTRA/:CB213_NR_CPFCNPJ',
            templateUrl: 'collect/partial/contrato/contrato-form.html',
            controller: 'ContratoFormCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                CB213_NR_OPERADOR: null,
                CB213_NR_CEDENTE: null,
                CB213_NR_CONTRA: null,
                CB213_NR_CPFCNPJ: null
            },
            resolve: {
                getData: getData
            }
        };
    }

    getData.$inject = ['$state', '$stateParams', 'contratoService'];

    function getData($state, $stateParams, contratoService) {
        // Verificar pk
        if ($stateParams.CB213_NR_OPERADOR && $stateParams.CB213_NR_CEDENTE && $stateParams.CB213_NR_CONTRA && $stateParams.CB213_NR_CPFCNPJ) {
            $stateParams.id = $stateParams;
            return contratoService.getById($stateParams.id).then(success).catch(error);
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