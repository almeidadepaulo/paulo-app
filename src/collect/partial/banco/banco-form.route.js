(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('banco-form', getState());
    }

    function getState() {
        return {
            url: '/banco-form/:CB250_NR_OPERADOR/:CB250_NR_CEDENTE/:CB250_CD_COMPSC',
            templateUrl: 'collect/partial/banco/banco-form.html',
            controller: 'BancoFormCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                CB250_NR_OPERADOR: null,
                CB250_NR_CEDENTE: null,
                CB250_CD_COMPSC: null,
                CB250_NM_BANCO: null
            },
            resolve: {
                getData: getData
            }
        };
    }

    getData.$inject = ['$state', '$stateParams', 'bancoService'];

    function getData($state, $stateParams, bancoService) {
        // Verificar pk
        if ($stateParams.CB250_NR_OPERADOR && $stateParams.CB250_NR_CEDENTE && $stateParams.CB250_CD_COMPSC) {
            $stateParams.id = $stateParams;
            return bancoService.getById($stateParams.id).then(success).catch(error);
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