(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .factory('registerService', registerService);

    registerService.$inject = ['config', '$http', '$q', 'toastService', '$timeout'];

    function registerService(config, $http, $q, toastService, $timeout) {
        var service = {};

        service.create = create;

        return service;

        function create(data) {

            var req = $http({
                    url: config.REST_URL + '/register',
                    method: 'POST',
                    headers: { 'Content-Type': undefined },
                    data: data
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