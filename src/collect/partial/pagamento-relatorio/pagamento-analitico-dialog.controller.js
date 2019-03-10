(function() {
    'use strict';

    angular.module('seeawayApp').controller('PagamentoAnaliticoDialogCtrl', PagamentoAnaliticoDialogCtrl);

    PagamentoAnaliticoDialogCtrl.$inject = ['pagamentoService', '$mdDialog', 'locals', '$filter', '$state'];

    function PagamentoAnaliticoDialogCtrl(pagamentoService, $mdDialog, locals, $filter, $state) {

        var vm = this;
        vm.init = init;
        vm.filter = {};
        vm.switch = 'list';
        vm.getData = getData;
        vm.entrada = {
            limit: 5,
            page: 1,
            selected: [],
            order: '',
            data: [],
            pagination: pagination,
            total: 0
        };
        vm.cancel = cancel;

        function init(event) {
            vm.state = $state.current.name;
            vm.title = locals.item.title || 'Analítico';
            vm.filter = locals.filter;
            getData({ reset: true });
        }

        function pagination(page, limit) {
            vm.entrada.data = [];
            getData();
        }

        function getData(params) {
            params = params || {};

            //console.info('locals', locals);

            vm.filter.page = vm.entrada.page;
            vm.filter.limit = vm.entrada.limit;

            if (params.reset) {
                vm.entrada.data = [];
            }

            vm.entrada.promise = pagamentoService.get(vm.filter)
                .then(function success(response) {
                    //console.info('success', response);
                    vm.entrada.total = response.recordCount;
                    vm.entrada.data = vm.entrada.data.concat(response.query);
                }, function error(response) {
                    console.error('error', response);
                });
        }

        function cancel() {
            $mdDialog.cancel();
        }
    }
})();