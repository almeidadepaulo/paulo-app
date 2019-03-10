(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('sms-mensagem-form', getState());
    }

    function getState() {
        return {
            url: '/sms-mensagem-form/:MG061_NR_INST/:MG061_CD_EMIEMP/:MG061_CD_CODSMS',
            templateUrl: 'publish/partial/sms-mensagem/sms-mensagem-form.html',
            controller: 'SmsMensagemFormCtrl',
            controllerAs: 'vm',
            parent: 'home',
            resolve: {
                getData: getData
            }
        };
    }

    getData.$inject = ['$state', '$stateParams', 'smsMensagemService'];

    function getData($state, $stateParams, smsMensagemService) {
        console.info('$stateParams', $stateParams);

        // Verificar pk
        if ($stateParams.MG061_NR_INST && $stateParams.MG061_CD_EMIEMP && $stateParams.MG061_CD_CODSMS) {
            $stateParams.id = $stateParams;
            return smsMensagemService.getById($stateParams.id).then(success).catch(error);
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