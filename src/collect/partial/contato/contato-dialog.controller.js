(function() {
    'use strict';

    angular.module('seeawayApp').controller('ContatoDialogCtrl', ContatoDialogCtrl);

    ContatoDialogCtrl.$inject = ['config', 'contatoService', '$rootScope', '$scope', '$state', '$mdDialog'];

    function ContatoDialogCtrl(config, contatoService, $rootScope, $scope, $state, $mdDialog) {

        var vm = this;
        vm.init = init;
        vm.filter = {};
        vm.getData = getData;
        vm.contato = {
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
            vm.contato.data = [];
            getData();
        }

        function getData(params) {
            params = params || {};

            vm.filter = vm.filter || {};
            vm.filter.page = vm.contato.page;
            vm.filter.limit = vm.contato.limit;

            if (params.reset) {
                vm.conta.data = [];
            }

            vm.contato.promise = contatoService.get(vm.filter)
                .then(function success(response) {
                    //console.info('success', response);
                    vm.contato.total = response.recordCount;
                    vm.contato.data = vm.contato.data.concat(response.query);
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