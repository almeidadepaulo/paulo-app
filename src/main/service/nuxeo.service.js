(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .factory('nuxeoService', nuxeoService);

    nuxeoService.$inject = ['config', '$http', '$q', 'toastService', '$timeout'];

    function nuxeoService(config, $http, $q, toastService, $timeout) {
        var service = {};

        service.getToken = getToken;

        return service;

        function getToken(params) {

            var req = $http({
                    url: config.REST_URL + '/nuxeo/token',
                    method: 'GET',
                    headers: {
                        'Authorization': '',
                        'Content-Type': 'application/json'
                    },
                    params: params
                })
                .then(handleSuccess, handleError);

            return req;
        }

        // private functions

        function handleSuccess(response) {
            console.info('handleSuccess', response);
            if (response.data.message && response.data.message !== '') {

                toastService.message(response);

            }

            return response.data;
        }

        function handleError(response) {
            console.info('handleError', response);
            if (!angular.isObject(response.data) || !response.data.Message) {
                response.data.Message = 'Ops! Ocorreu um erro desconhecido';
            }

            toastService.message(response);

            return ($q.reject(response.data.Message));
        }
    }

})();