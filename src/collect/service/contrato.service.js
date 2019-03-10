(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .factory('contratoService', contratoService);

    contratoService.$inject = ['config', '$http', '$q', 'toastService', '$timeout'];

    function contratoService(config, $http, $q, toastService, $timeout) {
        var service = {};

        service.get = get;
        service.getById = getById;

        return service;

        function get(params) {

            var req = $http({
                    url: config.REST_URL + '/collect/contrato',
                    method: 'GET',
                    headers: {
                        'Authorization': '',
                        'Content-Type': 'application/json',
                        'Cedente': localStorage.getItem('cedente')
                    },
                    params: params
                })
                .then(handleSuccess, handleError);

            return req;
        }

        function getById(id) {

            var _id = id.CB213_NR_OPERADOR;
            _id += '/' + id.CB213_NR_CEDENTE;
            _id += '/' + id.CB213_NR_CONTRA;
            _id += '/' + id.CB213_NR_CPFCNPJ;

            var req = $http({
                    url: config.REST_URL + '/collect/contrato/' + _id,
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