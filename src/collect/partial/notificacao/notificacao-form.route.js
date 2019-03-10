(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('notificacao-form', getState());
    }

    function getState() {
        return {
            url: '/notificacao-form/:CB261_NR_OPERADOR/:CB261_NR_CEDENTE/:CB261_CD_COMPSC/:CB261_NR_AGENC/:CB261_NR_CONTA/:CB261_CD_PUBLIC/:CB261_CD_MSG',
            templateUrl: 'collect/partial/notificacao/notificacao-form.html',
            controller: 'NotificacaoFormCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                CB261_NR_OPERADOR: null,
                CB261_NR_CEDENTE: null,
                CB261_CD_COMPSC: null,
                CB261_NR_AGENC: null,
                CB261_NR_CONTA: null,
                CB261_CD_PUBLIC: null,
                CB261_CD_MSG: null
            },
            resolve: {
                getData: getData
            }
        };
    }

    getData.$inject = ['$state', '$stateParams', 'notificacaoService'];

    function getData($state, $stateParams, notificacaoService) {
        // Verificar pk
        if ($stateParams.CB261_NR_OPERADOR && $stateParams.CB261_NR_CEDENTE && $stateParams.CB261_CD_COMPSC &&
            $stateParams.CB261_NR_AGENC && $stateParams.CB261_NR_CONTA && $stateParams.CB261_CD_PUBLIC && $stateParams.CB261_CD_MSG) {
            $stateParams.id = $stateParams;
            return notificacaoService.getById($stateParams.id).then(success).catch(error);
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