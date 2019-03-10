(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .factory('pagamentoService', pagamentoService);

    pagamentoService.$inject = ['config', '$http', '$q', 'toastService', '$timeout'];

    function pagamentoService(config, $http, $q, toastService, $timeout) {
        var service = {};

        service.get = get;
        service.getById = getById;
        service.update = update;
        service.pdf = pdf;
        service.pdfEmail = pdfEmail;

        return service;

        function get(params) {

            var req = $http({
                    url: config.REST_URL + '/collect/pagamento',
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

            var _id = id.CB210_NR_OPERADOR;
            _id += '/' + id.CB210_NR_CEDENTE;
            _id += '/' + id.CB210_CD_COMPSC;
            _id += '/' + id.CB210_NR_AGENC;
            _id += '/' + id.CB210_NR_CONTA;
            _id += '/' + id.CB210_NR_NOSNUM;
            _id += '/' + id.CB210_NR_CPFCNPJ;
            _id += '/' + id.CB210_NR_PROTOC;

            var req = $http({
                    url: config.REST_URL + '/collect/pagamento/' + _id,
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

            var _id = id.CB210_NR_OPERADOR;
            _id += '/' + id.CB210_NR_CEDENTE;
            _id += '/' + id.CB210_CD_COMPSC;
            _id += '/' + id.CB210_NR_AGENC;
            _id += '/' + id.CB210_NR_CONTA;
            _id += '/' + id.CB210_NR_NOSNUM;
            _id += '/' + id.CB210_NR_CPFCNPJ;
            _id += '/' + id.CB210_NR_PROTOC;

            var req = $http({
                    url: config.REST_URL + '/collect/pagamento/' + _id,
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

        function pdf(data) {

            var req = $http({
                    url: config.REST_URL + '/collect/pagamento/pdf',
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

        function pdfEmail(data) {

            var req = $http({
                    url: config.REST_URL + '/collect/pagamento/pdf-email',
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