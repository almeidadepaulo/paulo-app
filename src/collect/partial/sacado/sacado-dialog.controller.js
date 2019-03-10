(function() {
    'use strict';

    angular.module('seeawayApp').controller('SacadoDialogCtrl', SacadoDialogCtrl);

    SacadoDialogCtrl.$inject = ['config', 'sacadoService', '$rootScope', '$scope', '$state', '$mdDialog', 'locals'];

    function SacadoDialogCtrl(config, sacadoService, $rootScope, $scope, $state, $mdDialog, locals) {

        var vm = this;
        vm.init = init;
        vm.filter = {};
        vm.getData = getData;
        vm.sacado = {
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
            vm.sacado.data = [];
            getData();
        }

        function getData(params) {
            params = params || {};

            vm.filter = vm.filter || {};
            vm.filter.page = vm.sacado.page;
            vm.filter.limit = vm.sacado.limit;

            if (params.reset) {
                vm.sacado.data = [];
            }

            vm.sacado.promise = sacadoService.get(vm.filter)
                .then(function success(response) {
                    //console.info('success', response);
                    vm.sacado.total = response.recordCount;
                    vm.sacado.data = vm.sacado.data.concat(response.query);
                }, function error(response) {
                    console.error('error', response);
                });
        }

        function itemClick(item) {
            item = {
                id: item.CB201_NR_CPFCNPJ,
                name: item.CB201_NM_NMSAC,
                item: item
            };
            $mdDialog.hide(item);
        }

        function cancel() {
            $mdDialog.cancel();
        }
    }
})();