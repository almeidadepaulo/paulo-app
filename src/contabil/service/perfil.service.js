(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .factory('perfilService', perfilService);

    perfilService.$inject = ['config', '$http', '$mdToast', '$timeout'];

    function perfilService(config, $http, $mdToast, $timeout) {
        var service = {};

        service.getById = getById;
        service.create = create;
        service.update = update;
        service.remove = remove;
        service.removeById = removeById;
        service.jsTreeCedente = jsTreeCedente;
        //service.saveTreeCedente = saveTreeCedente;

        return service;

        function getById(id) {

            var req = $http({
                    url: config.REST_URL + '/contabil/perfil/' + id,
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
                    url: config.REST_URL + '/contabil/perfil/',
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
                    url: config.REST_URL + '/contabil/perfil/' + id,
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
                    url: config.REST_URL + '/contabil/perfil/',
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
                    url: config.REST_URL + '/contabil/perfil/' + id,
                    method: 'DELETE',
                    headers: {
                        'Content-Type': 'application/json'
                    }
                })
                .then(handleSuccess, handleError('Error removeById'));

            return req;
        }

        function jsTreeCedente(perfil, operador, callback) {
            var req = $http({
                    url: config.REST_URL + '/contabil/perfil/' + perfil + '/' + operador,
                    method: 'GET',
                    headers: {
                        'Content-Type': 'application/json'
                    }
                })
                .then(handleSuccess, handleError('Error update'));

            return req;
        }

        /*function saveTreeCedente(id, perfil_id, data, callback) {
            var params = {                
                user: $rootScope.globals.currentUser.usu_id,
                id: id,
                perfil_id: perfil_id,
                perfil_cedente: $rootScope.globals.currentUser.perfil_cedente,
                data: angular.toJson(data)
            };
            $http({
                method: 'POST',
                url: 'directives/config-perfil/config-perfil.cfc?method=saveTreeCedente',
                params: params
            }).success(function(response) {
                callback(response);
            }).
            error(function(data, status, headers, config) {
                // Erro
                alert('Ops! Ocorreu um erro inesperado.\nPor favor contate o administrador do sistema!');
            });
        }*/

        // private functions

        function handleSuccess(response) {
            if (response.data.message && response.data.message !== '') {
                $timeout(function() {
                    $mdToast.show(
                        $mdToast.simple()
                        .textContent(response.data.message)
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