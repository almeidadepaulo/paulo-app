(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('sms-parametro-form', getState());
    }

    function getState() {
        return {
            url: '/sms-parametro-form/',
            templateUrl: 'publish/partial/sms-parametro/sms-parametro-form.html',
            controller: 'SmsParametroFormCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                MG000_NR_INST: 1
            },
            resolve: {
                getData: getData
            }
        };
    }

    getData.$inject = ['$state', '$stateParams', 'smsParametroService'];

    function getData($state, $stateParams, smsParametroService) {
        // Verificar pk
        if ($stateParams.MG000_NR_INST) {
            $stateParams.id = $stateParams;
            return smsParametroService.getById($stateParams.id).then(success).catch(error);
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