(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .factory('protocoloService', protocoloService);

    protocoloService.$inject = ['config', '$http', '$q', 'toastService', '$timeout'];

    function protocoloService(config, $http, $q, toastService, $timeout) {
        var service = {};

        service.getBlob = getBlob;

        return service;

        function getBlob(id) {

            var req = $http({
                    url: config.REST_URL + '/main/protocolo/' + id,
                    method: 'GET',
                    headers: {
                        'Authorization': '',
                        'Content-Type': 'application/json'
                    }
                })
                .then(handleSuccess, handleError);

            return req;
        }

        // private functions

        function handleSuccess(response) {
            //console.info('handleSuccess', response);
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