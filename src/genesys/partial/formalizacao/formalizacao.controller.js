(function() {
    'use strict';

    angular.module('seeawayApp').controller('FormalizacaoCtrl', FormalizacaoCtrl);

    FormalizacaoCtrl.$inject = ['config', 'nuxeoService', '$rootScope', '$scope', '$state', '$mdDialog'];

    function FormalizacaoCtrl(config, nuxeoService, $rootScope, $scope, $state, $mdDialog) {

        var vm = this;
        vm.init = init;

        function init() {
            nuxeoService.getToken()
                .then(function success(response) {
                    console.info('getToken', response);

                    var token = response.token;

                    var url = config.GENESYS_URL +
                        '/genesys-adm/#/login?' +
                        '?token=' + token;

                    //window.location = url;
                    window.open(url, '_blank');

                    $state.go('menu');
                }, function error(response) {
                    console.error(response);
                });
        }
    }
})();