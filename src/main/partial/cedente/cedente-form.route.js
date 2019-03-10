(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('cedente-form', getState());
    }

    function getState() {
        return {
            url: '/cedente-form/:CB053_NR_INST/:CB053_CD_EMIEMP',
            templateUrl: 'main/partial/cedente/cedente-form.html',
            controller: 'CedenteFormCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                CB053_NR_INST: null,
                CB053_CD_EMIEMP: null
            },
            resolve: {
                getData: getData
            }
        };
    }

    getData.$inject = ['$state', '$stateParams', 'cedenteService'];

    function getData($state, $stateParams, cedenteService) {
        // Verificar pk
        if ($stateParams.CB053_NR_INST && $stateParams.CB053_CD_EMIEMP) {
            $stateParams.id = $stateParams;
            return cedenteService.getById($stateParams.id).then(success).catch(error);
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