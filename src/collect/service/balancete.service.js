(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .factory('balanceteService', balanceteService);

    balanceteService.$inject = ['config', '$http', '$q', 'toastService', '$timeout'];

    function balanceteService(config, $http, $q, toastService, $timeout) {
        var service = {};

        service.get = get;
        service.getById = getById;

        return service;

        function get(params) {

            var req = $http({
                    url: config.REST_URL + '/collect/balancete',
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

            var _id = id.CB255_DS_PROD;
            _id += '/' + id.CB209_CD_COMPSC;
            _id += '/' + id.CB209_NR_AGENC;
            _id += '/' + id.CB209_NR_CONTA;
            _id += '/' + id.CB209_DT_MOVTO;

            var req = $http({
                    url: config.REST_URL + '/collect/balancete/' + _id,
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