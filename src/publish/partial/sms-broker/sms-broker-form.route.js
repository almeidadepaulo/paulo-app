(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('sms-broker-form', getState());
    }

    function getState() {
        return {
            url: '/sms-broker-form/:MG050_NR_OPERADOR/:MG050_NR_CEDENTE/:MG050_NR_BROKER',
            templateUrl: 'publish/partial/sms-broker/sms-broker-form.html',
            controller: 'SmsBrokerFormCtrl',
            controllerAs: 'vm',
            parent: 'home',
            resolve: {
                getData: getData
            }
        };
    }

    getData.$inject = ['$state', '$stateParams', 'smsBrokerService'];

    function getData($state, $stateParams, smsBrokerService) {
        console.info('$stateParams', $stateParams);

        // Verificar pk
        if ($stateParams.MG050_NR_OPERADOR && $stateParams.MG050_NR_CEDENTE && $stateParams.MG050_NR_BROKER) {
            $stateParams.id = $stateParams;
            return smsBrokerService.getById($stateParams.id).then(success).catch(error);
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