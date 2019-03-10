(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('email-mensagem-form', getState());
    }

    function getState() {
        return {
            url: '/email-mensagem-form/:EM061_NR_INST/:EM061_CD_EMIEMP/:EM061_CD_CODEMAIL',
            templateUrl: 'publish/partial/email-mensagem/email-mensagem-form.html',
            controller: 'EmailMensagemFormCtrl',
            controllerAs: 'vm',
            parent: 'home',
            resolve: {
                getData: getData
            }
        };
    }

    getData.$inject = ['$state', '$stateParams', 'emailMensagemService'];

    function getData($state, $stateParams, emailMensagemService) {
        console.info('$stateParams', $stateParams);

        // Verificar pk
        if ($stateParams.EM061_NR_INST && $stateParams.EM061_CD_EMIEMP && $stateParams.EM061_CD_CODEMAIL) {
            $stateParams.id = $stateParams;
            return emailMensagemService.getById($stateParams.id).then(success).catch(error);
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