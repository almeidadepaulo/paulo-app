(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('tarifas-form', getState());
    }

    function getState() {
        return {
            url: '/tarifas-form/:CB059_NR_OPERADOR/:CB059_NR_CEDENTE/:CB059_NR_BANCO/:CB059_CD_TARIFA',
            templateUrl: 'collect/partial/tarifas/tarifas-form.html',
            controller: 'TarifasFormCtrl',
            controllerAs: 'vm',
            parent: 'home',
            resolve: {
                getData: getData
            }
        };
    }

    getData.$inject = ['$state', '$stateParams', 'tarifasService'];

    function getData($state, $stateParams, tarifasService) {
        console.info('$stateParams', $stateParams);

        // Verificar pk
        if ($stateParams.CB059_NR_OPERADOR && $stateParams.CB059_NR_CEDENTE && $stateParams.CB059_NR_BANCO && $stateParams.CB059_CD_TARIFA) {
            $stateParams.id = $stateParams;
            return tarifasService.getById($stateParams.id).then(success).catch(error);
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