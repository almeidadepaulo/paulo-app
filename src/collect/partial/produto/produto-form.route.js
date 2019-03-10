(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('produto-form', getState());
    }

    function getState() {
        return {
            url: '/produto-form/:CB255_NR_OPERADOR/:CB255_NR_CEDENTE/:CB255_CD_PROD',
            templateUrl: 'collect/partial/produto/produto-form.html',
            controller: 'ProdutoFormCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                CB255_NR_OPERADOR: null,
                CB255_NR_CEDENTE: null,
                CB255_CD_PROD: null,
                CB255_DS_PROD: null
            },
            resolve: {
                getData: getData
            }
        };
    }

    getData.$inject = ['$state', '$stateParams', 'produtoService'];

    function getData($state, $stateParams, produtoService) {
        // Verificar pk
        if ($stateParams.CB255_NR_OPERADOR && $stateParams.CB255_NR_CEDENTE && $stateParams.CB255_CD_PROD) {
            $stateParams.id = $stateParams;
            return produtoService.getById($stateParams.id).then(success).catch(error);
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