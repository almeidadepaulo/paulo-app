(function() {
    'use strict';

    angular.module('seeawayApp').controller('EntradaAnaliticoDialogCtrl', EntradaAnaliticoDialogCtrl);

    EntradaAnaliticoDialogCtrl.$inject = ['entradaService', '$mdDialog', 'locals', '$filter'];

    function EntradaAnaliticoDialogCtrl(entradaService, $mdDialog, locals, $filter) {

        var vm = this;
        vm.init = init;
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
            getData({ reset: true });
        }

        function pagination(page, limit) {
            vm.entrada.data = [];
            getData();
        }

        function getData(params) {
            params = params || {};

            //console.info('locals', locals);
            vm.filter = vm.filter || {};
            vm.filter.page = vm.entrada.page;
            vm.filter.limit = vm.entrada.limit;

            vm.filter.CB209_DT_MOVTO = $filter('numberToDate')(locals.item.CB209_DT_MOVTO);

            if (params.reset) {
                vm.entrada.data = [];
            }

            vm.entrada.promise = entradaService.get(vm.filter)
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