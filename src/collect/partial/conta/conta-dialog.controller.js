(function() {
    'use strict';

    angular.module('seeawayApp').controller('ContaDialogCtrl', ContaDialogCtrl);

    ContaDialogCtrl.$inject = ['config', 'contaService', '$rootScope', '$scope', '$state', '$mdDialog', 'banco', 'agencia'];

    function ContaDialogCtrl(config, contaService, $rootScope, $scope, $state, $mdDialog, banco, agencia) {

        var vm = this;
        vm.init = init;
        vm.filter = {};
        vm.getData = getData;
        vm.conta = {
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
            if (banco.id) {
                vm.filter.CB260_CD_COMPSC = banco.id;
            }
            if (agencia.id) {
                vm.filter.CB260_NR_AGENC = agencia.id;
            }

            getData({ reset: true });
        }

        function pagination(page, limit) {
            vm.conta.data = [];
            getData();
        }

        function getData(params) {
            params = params || {};

            vm.filter = vm.filter || {};
            vm.filter.page = vm.conta.page;
            vm.filter.limit = vm.conta.limit;

            if (params.reset) {
                vm.conta.data = [];
            }

            vm.conta.promise = contaService.get(vm.filter)
                .then(function success(response) {
                    //console.info('success', response);
                    vm.conta.total = response.recordCount;
                    vm.conta.data = vm.conta.data.concat(response.query);
                }, function error(response) {
                    console.error('error', response);
                });
        }

        function itemClick(item) {
            item = {
                id: item.CB260_NR_CONTA,
                name: item.CB260_NR_CONTA
            };
            $mdDialog.hide(item);
        }

        function cancel() {
            $mdDialog.cancel();
        }
    }
})();