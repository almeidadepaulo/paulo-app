(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .factory('agendaService', agendaService);

    agendaService.$inject = ['config', '$http', '$mdToast', '$timeout'];

    function agendaService(config, $http, $mdToast, $timeout) {
        var service = {};

        service.getBoletoByRange = getBoletoByRange;

        return service;

        function getBoletoByRange(params) {

            var req = $http({
                    url: config.REST_URL + '/epaybox/agenda/range',
                    method: 'GET',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    params: params
                })
                .then(handleSuccess, handleError('Error getBoletoByRange'));

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