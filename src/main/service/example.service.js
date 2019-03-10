(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .factory('exampleService', exampleService);

    exampleService.$inject = ['config', '$http', 'toastService', '$timeout'];

    function exampleService(config, $http, toastService, $timeout) {
        var service = {};

        service.getById = getById;
        service.create = create;
        service.update = update;
        service.remove = remove;
        service.removeById = removeById;

        return service;

        function getById(id) {

            var req = $http({
                    url: config.REST_URL + '/example/' + id,
                    method: 'GET',
                    headers: {
                        'Content-Type': 'application/json'
                    }
                })
                .then(handleSuccess, handleError('Error getById'));

            return req;
        }

        function create(data) {

            var req = $http({
                    url: config.REST_URL + '/example/',
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    data: data
                })
                .then(handleSuccess, handleError('Error update'));

            return req;
        }

        function update(id, data) {

            var req = $http({
                    url: config.REST_URL + '/example/' + id,
                    method: 'PUT',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    data: data
                })
                .then(handleSuccess, handleError('Error update'));

            return req;
        }

        function remove(data) {
            var req = $http({
                    url: config.REST_URL + '/example/',
                    method: 'DELETE',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    data: data
                })
                .then(handleSuccess, handleError('Error remove'));

            return req;
        }

        function removeById(id) {
            var req = $http({
                    url: config.REST_URL + '/example/' + id,
                    method: 'DELETE',
                    headers: {
                        'Content-Type': 'application/json'
                    }
                })
                .then(handleSuccess, handleError('Error removeById'));

            return req;
        }

        // private functions

        function handleSuccess(response) {
            if (response.data.message && response.data.message !== '') {
                toastService.message(response);
            }
            return response.data;
        }

        function handleError(error) {
            return function() {
                return { success: false, message: error };
            };
        }
    }

})();