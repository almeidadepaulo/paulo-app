(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('cessionario-form', getState());
    }

    function getState() {
        return {
            url: '/cessionario-form/: CB058_NR_OPERADOR/: CB058_NR_CEDENTE/: CB058_CD_CESS',
            templateUrl: 'securities/partial/cessionario/cessionario-form.html',
            controller: 'CessionarioFormCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                CB058_NR_OPERADOR: null,
                CB058_NR_CEDENTE: null,
                CB058_CD_CESS: null
            },
            resolve: {
                getData: getData
            }
        };
    }

    getData.$inject = ['$state', '$stateParams', 'cessionarioService'];

    function getData($state, $stateParams, cessionarioService) {
        // Verificar pk
        if ($stateParams.CB058_NR_OPERADOR && $stateParams.CB058_NR_CEDENTE && $stateParams.CB058_CD_CESS) {
            $stateParams.id = $stateParams;
            return cessionarioService.getById($stateParams.id).then(success).catch(error);
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