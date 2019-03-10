(function() {
    'use strict';

    angular.module('seeawayApp').controller('PerfilAcessoDialogCtrl', PerfilAcessoDialogCtrl);

    PerfilAcessoDialogCtrl.$inject = ['config', 'perfilService', '$rootScope', '$scope', '$state', '$mdDialog', 'locals'];

    function PerfilAcessoDialogCtrl(config, perfilService, $rootScope, $scope, $state, $mdDialog, locals) {

        var vm = this;
        vm.init = init;
        vm.getData = getData;
        vm.perfil = {
            limit: 5,
            page: 1,
            selected: [],
            order: '',
            data: [],
            pagination: pagination,
            total: 0
        };
        vm.itemClick = itemClick;
        vm.cancel = cancel;

        function init(event) {
            getData({ reset: true });
        }

        function pagination(page, limit) {
            vm.perfil.data = [];
            getData();
        }

        function getData(params) {
            params = params || {};

            vm.filter = vm.filter || {};
            vm.filter.page = vm.perfil.page;
            vm.filter.limit = vm.perfil.limit;

            if (params.reset) {
                vm.perfil.data = [];
            }

            vm.perfil.promise = perfilService.get(vm.filter)
                .then(function success(response) {
                    //console.info('success', response);
                    vm.perfil.total = response.recordCount;
                    vm.perfil.data = vm.perfil.data.concat(response.query);
                }, function error(response) {
                    console.error('error', response);
                });
        }

        function itemClick(item) {
            $mdDialog.hide(item);
        }

        function cancel() {
            $mdDialog.cancel();
        }
    }
})();