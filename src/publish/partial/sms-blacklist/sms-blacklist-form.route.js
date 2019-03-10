(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('sms-blacklist-form', getState());
    }

    function getState() {
        return {
            url: '/sms-blacklist-form/:MG065_NR_INST/:MG065_NR_DDD/:MG065_NR_CEL',
            templateUrl: 'publish/partial/sms-blacklist/sms-blacklist-form.html',
            controller: 'SmsBlacklistFormCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                MG065_NR_INST: null,
                MG065_NR_DDD: null,
                MG065_NR_CEL: null
            },
            resolve: {
                getData: getData
            }
        };
    }

    getData.$inject = ['$state', '$stateParams', 'smsBlacklistService'];

    function getData($state, $stateParams, smsBlacklistService) {
        // Verificar pk
        if ($stateParams.MG065_NR_INST && $stateParams.MG065_NR_DDD && $stateParams.MG065_NR_CEL) {
            $stateParams.id = $stateParams;
            return smsBlacklistService.getById($stateParams.id).then(success).catch(error);
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