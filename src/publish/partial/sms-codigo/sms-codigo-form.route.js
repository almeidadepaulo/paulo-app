(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('sms-codigo-form', getState());
    }

    function getState() {
        return {
            url: '/sms-codigo-form/:MG055_NR_INST/:MG055_CD_EMIEMP/:MG055_CD_CODSMS',
            templateUrl: 'publish/partial/sms-codigo/sms-codigo-form.html',
            controller: 'SmsCodigoFormCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                MG055_NR_INST: null,
                MG055_CD_EMIEMP: null,
                MG055_CD_CODSMS: null
            },
            resolve: {
                getData: getData
            }
        };
    }

    getData.$inject = ['$state', '$stateParams', 'smsCodigoService'];

    function getData($state, $stateParams, smsCodigoService) {
        // Verificar pk
        if ($stateParams.MG055_NR_INST && $stateParams.MG055_CD_EMIEMP && $stateParams.MG055_CD_CODSMS) {
            $stateParams.id = $stateParams;
            return smsCodigoService.getById($stateParams.id).then(success).catch(error);
        } else {
            return {};
        }

        function success(response) {
            console.info(response);
            return {
                codigo: response.query[0],
                pacotes: response.queryPacotes
            };
        }

        function error(response) {
            console.error(response);
            return response;
        }
    }
})();