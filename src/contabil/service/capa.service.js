(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .factory('capaService', capaService);

    capaService.$inject = ['config', '$http', '$mdToast', '$timeout'];

    function capaService(config, $http, $mdToast, $timeout) {
        var service = {};

        service.capaPdf = capaPdf;

        return service;

        function capaPdf(data) {

            var req = $http({
                    url: config.REST_URL + '/contabil/capa/pdf',
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    data: data
                })
                .then(handleSuccess, handleError('capaPdf'));

            return req;
        }

        // private functions

        function handleSuccess(response) {
            return response.data;
        }

        function handleError(error) {
            return function() {
                return { success: false, message: error };
            };
        }
    }

})();