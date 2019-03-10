(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('conta-contabil-form', getState());
    }

    function getState() {
        return {
            url: '/conta-contabil-form',
            templateUrl: 'collect/partial/conta-contabil/conta-contabil-form.html',
            controller: 'ContaContabilFormCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                'id': null
            },
            resolve: {
                getData: getData
            }
        };
    }

    getData.$inject = ['$state', '$stateParams'];

    function getData($state, $stateParams) {

        if ($stateParams.id) {
            // fake
            return { example: $stateParams.id };
            //return exampleService.getById($stateParams.id).then(success).catch(error);
        } else {
            return {};
        }

        function success(response) {
            console.info(response);
            return response;
        }

        function error(response) {
            console.error(response);
            return response;
        }
    }
})();