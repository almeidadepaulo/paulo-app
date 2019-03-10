(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('email-blacklist-form', getState());
    }

    function getState() {
        return {
            url: '/email-blacklist-form/:EM065_NR_INST/:EM065_NR_CPFCNPJ/:EM065_DS_EMAIL',
            templateUrl: 'publish/partial/email-blacklist/email-blacklist-form.html',
            controller: 'EmailBlacklistFormCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                EM065_NR_INST: null,
                EM065_NR_CPFCNPJ: null,
                EM065_DS_EMAIL: null
            },
            resolve: {
                getData: getData
            }
        };
    }

    getData.$inject = ['$state', '$stateParams', 'emailBlacklistService'];

    function getData($state, $stateParams, emailBlacklistService) {
        // Verificar pk
        if ($stateParams.EM065_NR_INST && $stateParams.EM065_DS_EMAIL && $stateParams.EM065_DS_EMAIL) {
            $stateParams.id = $stateParams;
            return emailBlacklistService.getById($stateParams.id).then(success).catch(error);
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