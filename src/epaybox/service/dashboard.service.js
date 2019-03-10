(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .factory('dashboardService', dashboardService);

    dashboardService.$inject = ['config', '$http', '$mdToast', '$timeout'];

    function dashboardService(config, $http, $mdToast, $timeout) {
        var service = {};

        service.getBoletoStatus = getBoletoStatus;

        return service;

        function getBoletoStatus() {

            var req = $http({
                    url: config.REST_URL + '/epaybox/dashboard/boletoStatus/',
                    method: 'GET',
                    headers: {
                        'Content-Type': 'application/json'
                    }
                })
                .then(handleSuccess, handleError('Error getBoletoStatus'));

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