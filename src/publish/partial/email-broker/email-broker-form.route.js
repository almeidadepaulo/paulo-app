(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('email-broker-form', getState());
    }

    function getState() {
        return {
            url: '/email-broker-form/:EM050_NR_INST/:EM050_NR_BROKER',
            templateUrl: 'publish/partial/email-broker/email-broker-form.html',
            controller: 'EmailBrokerFormCtrl',
            controllerAs: 'vm',
            parent: 'home',
            resolve: {
                getData: getData
            }
        };
    }

    getData.$inject = ['$state', '$stateParams', 'emailBrokerService'];

    function getData($state, $stateParams, emailBrokerService) {
        console.info('$stateParams', $stateParams);

        // Verificar pk
        if ($stateParams.EM050_NR_INST && $stateParams.EM050_NR_BROKER) {
            $stateParams.id = $stateParams;
            return emailBrokerService.getById($stateParams.id).then(success).catch(error);
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