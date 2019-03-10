(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .factory('divergenciaService', divergenciaService);

    divergenciaService.$inject = ['config', '$http', '$q', 'toastService', '$timeout'];

    function divergenciaService(config, $http, $q, toastService, $timeout) {
        var service = {};

        service.get = get;
        service.getById = getById;

        return service;

        function get(params) {

            var req = $http({
                    url: config.REST_URL + '/collect/divergencia',
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

            var _id = id.CB057_NR_OPERADOR;
            _id += '/' + id.CB057_NR_CEDENTE;
            _id += '/' + id.CB057_DT_MOVTO;
            _id += '/' + id.CB057_NR_BANCO;
            _id += '/' + id.CB057_NR_AGENC;
            _id += '/' + id.CB057_NR_CONTA;
            _id += '/' + id.CB057_NR_CONTRA;
            _id += '/' + id.CB057_NR_NOSNUM;

            var req = $http({
                    url: config.REST_URL + '/collect/divergencia/' + _id,
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