(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .factory('contaService', contaService);

    contaService.$inject = ['config', '$http', '$q', 'toastService', '$timeout'];

    function contaService(config, $http, $q, toastService, $timeout) {
        var service = {};

        service.get = get;
        service.getById = getById;
        service.create = create;
        service.update = update;
        service.remove = remove;
        service.removeById = removeById;

        return service;

        function get(params) {

            var req = $http({
                    url: config.REST_URL + '/collect/conta',
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

        function getById(id) {

            var _id = id.CB260_NR_OPERADOR;
            _id += '/' + id.CB260_NR_CEDENTE;
            _id += '/' + id.CB260_CD_COMPSC;
            _id += '/' + id.CB260_NR_AGENC;
            _id += '/' + id.CB260_NR_CONTA;
            _id += '/' + id.CB260_CD_CART;

            var req = $http({
                    url: config.REST_URL + '/collect/conta/' + _id,
                    method: 'GET',
                    headers: {
                        'Authorization': '',
                        'Content-Type': 'application/json'
                    }
                })
                .then(handleSuccess, handleError);

            return req;
        }

        function create(data) {

            var req = $http({
                    url: config.REST_URL + '/collect/conta',
                    method: 'POST',
                    headers: {
                        'Authorization': '',
                        'Content-Type': 'application/json'
                    },
                    data: data
                })
                .then(handleSuccess, handleError);

            return req;
        }

        function update(id, data) {

            var _id = id.CB260_NR_OPERADOR;
            _id += '/' + id.CB260_NR_CEDENTE;
            _id += '/' + id.CB260_CD_COMPSC;
            _id += '/' + id.CB260_NR_AGENC;
            _id += '/' + id.CB260_NR_CONTA;
            _id += '/' + id.CB260_CD_CART;

            var req = $http({
                    url: config.REST_URL + '/collect/conta/' + _id,
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

        function remove(data) {

            var req = $http({
                    url: config.REST_URL + '/collect/conta',
                    method: 'DELETE',
                    headers: {
                        'Authorization': '',
                        'Content-Type': 'application/json'
                    },
                    data: data
                })
                .then(handleSuccess, handleError);

            return req;
        }

        function removeById(id) {

            var _id = id.CB260_NR_OPERADOR;
            _id += '/' + id.CB260_NR_CEDENTE;
            _id += '/' + id.CB260_CD_COMPSC;
            _id += '/' + id.CB260_NR_AGENC;
            _id += '/' + id.CB260_NR_CONTA;
            _id += '/' + id.CB260_CD_CART;

            var req = $http({
                    url: config.REST_URL + '/collect/conta/' + _id,
                    method: 'DELETE',
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