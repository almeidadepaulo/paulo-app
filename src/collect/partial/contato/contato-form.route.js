(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('contato-form', getState());
    }

    function getState() {
        return {
            url: '/contato-form/:CB054_NR_INST/:CB054_CD_EMIEMP/:CB054_NR_SEQ',
            templateUrl: 'collect/partial/contato/contato-form.html',
            controller: 'ContatoFormCtrl',
            controllerAs: 'vm',
            parent: 'home',
            resolve: {
                getData: getData
            }
        };
    }

    getData.$inject = ['$state', '$stateParams', 'contatoService'];

    function getData($state, $stateParams, contatoService) {
        console.info('$stateParams', $stateParams);

        // Verificar pk
        if ($stateParams.CB054_NR_INST && $stateParams.CB054_CD_EMIEMP && $stateParams.CB054_NR_SEQ) {
            $stateParams.id = $stateParams;
            return contatoService.getById($stateParams.id).then(success).catch(error);
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