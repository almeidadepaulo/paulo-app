(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .factory('usuarioService', usuarioService);

    usuarioService.$inject = ['config', '$http', '$mdToast', '$timeout'];

    function usuarioService(config, $http, $mdToast, $timeout) {
        var service = {};

        service.getById = getById;
        service.create = create;
        service.update = update;
        service.remove = remove;
        service.removeById = removeById;

        return service;

        function getById(id) {

            var req = $http({
                    url: config.REST_URL + '/contabil/usuario/' + id,
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
                    url: config.REST_URL + '/contabil/usuario/',
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
                    url: config.REST_URL + '/contabil/usuario/' + id,
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
                    url: config.REST_URL + '/contabil/usuario/',
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
                    url: config.REST_URL + '/contabil/usuario/' + id,
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
                $timeout(function() {
                    $mdToast.show(
                        $mdToast.simple()
                        .textContent(response.data.message)
                        .action('Fechar')
                        .highlightAction(true)
                        .position('bottom right')
                        .hideDelay(3500)
                    );
                }, 1000);
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