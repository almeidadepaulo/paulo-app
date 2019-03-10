(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .factory('segundaViaService', segundaViaService);

    segundaViaService.$inject = ['config', '$http', '$mdToast', '$timeout'];

    function segundaViaService(config, $http, $mdToast, $timeout) {
        var service = {};

        service.getBlobByProtocolo = getBlobByProtocolo;

        return service;

        function getBlobByProtocolo(data) {

            var req = $http({
                    url: config.REST_URL + '/epaybox/2via/boleto',
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    data: data
                })
                .then(handleSuccess, handleError('Error getBlobByProtocolo'));

            return req;
        }

        // private functions

        function handleSuccess(response) {
            if (response.data.message && response.data.message !== '') {
                $timeout(function() {
                    $mdToast.show(
                        $mdToast.simple()
                        .textContent(response.data.message)
                        .position('bottom right')
                        .hideDelay(3500)
                    );
                }, 1000);
            }
            return response.data;
        }

        function handleError(error) {
            return function() {
                return { success: false, message: error };
            };
        }
    }

})();