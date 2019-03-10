(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .factory('smsParametroService', smsParametroService);

    smsParametroService.$inject = ['config', '$http', '$q', 'toastService', '$timeout'];

    function smsParametroService(config, $http, $q, toastService, $timeout) {
        var service = {};

        service.getById = getById;
        service.update = update;

        return service;

        function getById(id) {

            var _id = id.MG000_NR_INST;

            var req = $http({
                    url: config.REST_URL + '/publish/sms/parametro/' + _id,
                    method: 'GET',
                    headers: {
                        'Authorization': '',
                        'Content-Type': 'application/json'
                    }
                })
                .then(handleSuccess, handleError);

            return req;
        }


        function update(id, data) {

            var _id = id.MG000_NR_INST;

            var req = $http({
                    url: config.REST_URL + '/publish/sms/parametro/' + _id,
                    method: 'PUT',
                    headers: {
                        'Authorization': '',
                        'Content-Type': 'application/json'
                    },
                    data: data
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