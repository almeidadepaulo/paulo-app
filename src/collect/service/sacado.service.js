(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .factory('sacadoService', sacadoService);

    sacadoService.$inject = ['config', '$http', '$q', 'toastService', '$timeout'];

    function sacadoService(config, $http, $q, toastService, $timeout) {
        var service = {};

        service.get = get;
        service.getById = getById;

        return service;

        function get(params) {

            var req = $http({
                    url: config.REST_URL + '/collect/sacado',
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

            var _id = id.CB201_NR_OPERADOR;
            _id += '/' + id.CB201_NR_CEDENTE;
            _id += '/' + id.CB201_CD_COMPSC;
            _id += '/' + id.CB201_NR_AGENC;
            _id += '/' + id.CB201_NR_CONTA;
            _id += '/' + id.CB201_CD_FORMU;
            _id += '/' + id.CB201_NR_SEQ;
            _id += '/' + id.CB201_NR_NOSNUM;

            var req = $http({
                    url: config.REST_URL + '/collect/sacado/' + _id,
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