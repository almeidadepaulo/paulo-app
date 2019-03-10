(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('roteiro-contabil-form', getState());
    }

    function getState() {
        return {
            url: '/roteiro-contabil-form/:BKN509_NR_OPERADOR/:BKN509_NR_CEDENTE/:BKN509_CD_ROTCT',
            templateUrl: 'collect/partial/roteiro-contabil/roteiro-contabil-form.html',
            controller: 'RoteiroContabilFormCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                BKN509_NR_OPERADOR: null,
                BKN509_NR_CEDENTE: null,
                BKN509_CD_ROTCT: null
            },
            resolve: {
                getData: getData
            }
        };
    }

    getData.$inject = ['$state', '$stateParams', 'roteiroContabilService'];

    function getData($state, $stateParams, roteiroContabilService) {
        // Verificar pk
        if ($stateParams.BKN509_NR_OPERADOR && $stateParams.BKN509_NR_CEDENTE && $stateParams.BKN509_CD_ROTCT) {
            $stateParams.id = $stateParams;
            return roteiroContabilService.getById($stateParams.id).then(success).catch(error);
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