(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('email-codigo-form', getState());
    }

    function getState() {
        return {
            url: '/email-codigo-form/:EM055_NR_INST/:EM055_CD_EMIEMP/:EM055_CD_CODEMAIL',
            templateUrl: 'publish/partial/email-codigo/email-codigo-form.html',
            controller: 'EmailCodigoFormCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                EM055_NR_INST: null,
                EM055_CD_EMIEMP: null,
                EM055_CD_CODEMAIL: null
            },
            resolve: {
                getData: getData
            }
        };
    }

    getData.$inject = ['$state', '$stateParams', 'emailCodigoService'];

    function getData($state, $stateParams, emailCodigoService) {
        // Verificar pk
        if ($stateParams.EM055_NR_INST && $stateParams.EM055_CD_EMIEMP && $stateParams.EM055_CD_CODEMAIL) {
            $stateParams.id = $stateParams;
            return emailCodigoService.getById($stateParams.id).then(success).catch(error);
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