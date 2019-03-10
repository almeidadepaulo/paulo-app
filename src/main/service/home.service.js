(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .factory('homeService', homeService);

    homeService.$inject = ['config', '$http', '$q', 'toastService', '$timeout'];

    function homeService(config, $http, $q, toastService, $timeout) {
        var service = {};

        service.getMenu = getMenu;
        service.getChildren = getChildren;

        return service;

        function getMenu(params) {

            params = params || {};
            params.projectId = config.PROJECT_ID;

            var req = $http({
                    url: config.REST_URL + '/home/menu',
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

        function getChildren(id, params) {

            params = params || {};
            params.projectId = config.PROJECT_ID;

            var req = $http({
                    url: config.REST_URL + '/home/menu/' + id + '/menu',
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