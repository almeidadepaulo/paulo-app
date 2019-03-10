(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('ocorrencia-form', getState());
    }

    function getState() {
        return {
            url: '/ocorrencia-form',
            templateUrl: 'contabil/partial/ocorrencia/ocorrencia-form.html',
            controller: 'OcorrenciaFormCtrl',
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

    getData.$inject = ['$state', '$stateParams', 'exampleService'];

    function getData($state, $stateParams, exampleService) {

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