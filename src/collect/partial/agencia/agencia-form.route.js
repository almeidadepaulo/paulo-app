(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('agencia-form', getState());
    }

    function getState() {
        return {
            url: '/agencia-form/:CB251_NR_OPERADOR/:CB251_NR_CEDENTE/:CB251_CD_COMPSC/:CB251_NR_AGENC',
            templateUrl: 'collect/partial/agencia/agencia-form.html',
            controller: 'AgenciaFormCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                CB251_NR_OPERADOR: null,
                CB251_NR_CEDENTE: null,
                CB251_CD_COMPSC: null,
                CB251_NR_AGENC: null
            },
            resolve: {
                getData: getData
            }
        };
    }

    getData.$inject = ['$state', '$stateParams', 'agenciaService'];

    function getData($state, $stateParams, agenciaService) {
        // Verificar pk
        if ($stateParams.CB251_NR_OPERADOR && $stateParams.CB251_NR_CEDENTE && $stateParams.CB251_CD_COMPSC && $stateParams.CB251_NR_AGENC) {
            $stateParams.id = $stateParams;
            return agenciaService.getById($stateParams.id).then(success).catch(error);
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