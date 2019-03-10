(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('carteira-form', getState());
    }

    function getState() {
        return {
            url: '/carteira-form/:CB256_NR_OPERADOR/:CB256_NR_CEDENTE/:CB256_CD_CART',
            templateUrl: 'collect/partial/carteira/carteira-form.html',
            controller: 'CarteiraFormCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                CB256_NR_OPERADOR: null,
                CB256_NR_CEDENTE: null,
                CB256_CD_CART: null,
                CB256_DS_CART: null
            },
            resolve: {
                getData: getData
            }
        };
    }

    getData.$inject = ['$state', '$stateParams', 'carteiraService'];

    function getData($state, $stateParams, carteiraService) {
        // Verificar pk
        if ($stateParams.CB256_NR_OPERADOR && $stateParams.CB256_NR_CEDENTE && $stateParams.CB256_CD_CART) {
            $stateParams.id = $stateParams;
            return carteiraService.getById($stateParams.id).then(success).catch(error);
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