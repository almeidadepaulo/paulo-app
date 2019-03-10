(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .factory('roteiroContabilService', roteiroContabilService);

    roteiroContabilService.$inject = ['config', '$http', '$q', 'toastService', '$timeout'];

    function roteiroContabilService(config, $http, $q, toastService, $timeout) {
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
                    url: config.REST_URL + '/collect/roteiro-contabil',
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

            var _id = id.BKN509_NR_OPERADOR;
            _id += '/' + id.BKN509_NR_CEDENTE;
            _id += '/' + id.BKN509_CD_ROTCT;

            var req = $http({
                    url: config.REST_URL + '/collect/roteiro-contabil/' + _id,
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
                    url: config.REST_URL + '/collect/roteiro-contabil',
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

            var _id = id.BKN509_NR_OPERADOR;
            _id += '/' + id.BKN509_NR_CEDENTE;
            _id += '/' + id.BKN509_CD_ROTCT;

            var req = $http({
                    url: config.REST_URL + '/collect/roteiro-contabil/' + _id,
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
                    url: config.REST_URL + '/collect/roteiro-contabil',
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

            var _id = id.BKN509_NR_OPERADOR;
            _id += '/' + id.BKN509_NR_CEDENTE;
            _id += '/' + id.BKN509_CD_ROTCT;

            var req = $http({
                    url: config.REST_URL + '/collect/roteiro-contabil/' + _id,
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