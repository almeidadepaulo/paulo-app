(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('email-pacote-form', getState());
    }

    function getState() {
        return {
            url: '/email-pacote-form/:EM070_NR_INST/:EM070_NR_PACOTE',
            templateUrl: 'publish/partial/email-pacote/email-pacote-form.html',
            controller: 'EmailPacoteFormCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                EM070_NR_INST: null,
                EM070_NR_PACOTE: null
            },
            resolve: {
                getData: getData
            }
        };
    }

    getData.$inject = ['$state', '$stateParams', 'emailPacoteService'];

    function getData($state, $stateParams, emailPacoteService) {
        // Verificar pk
        if ($stateParams.EM070_NR_INST && $stateParams.EM070_NR_PACOTE) {
            $stateParams.id = $stateParams;
            return emailPacoteService.getById($stateParams.id).then(success).catch(error);
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