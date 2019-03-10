(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('siclid-x-cosif-form', getState());
    }

    function getState() {
        return {
            url: '/siclid-x-cosif',
            templateUrl: 'contabil/partial/siclid-x-cosif/siclid-x-cosif-form.html',
            controller: 'SiclidXcosifFormCtrl',
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