(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('sms-pacote-form', getState());
    }

    function getState() {
        return {
            url: '/sms-pacote-form/:MG070_NR_INST/:MG070_NR_PACOTE',
            templateUrl: 'publish/partial/sms-pacote/sms-pacote-form.html',
            controller: 'SmsPacoteFormCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                MG070_NR_INST: null,
                MG070_NR_PACOTE: null
            },
            resolve: {
                getData: getData
            }
        };
    }

    getData.$inject = ['$state', '$stateParams', 'smsPacoteService'];

    function getData($state, $stateParams, smsPacoteService) {
        // Verificar pk
        if ($stateParams.MG070_NR_INST && $stateParams.MG070_NR_PACOTE) {
            $stateParams.id = $stateParams;
            return smsPacoteService.getById($stateParams.id).then(success).catch(error);
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