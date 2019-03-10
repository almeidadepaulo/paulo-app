(function() {
    'use strict';

    angular.module('seeawayApp').controller('CedenteDialogCtrl', CedenteDialogCtrl);

    CedenteDialogCtrl.$inject = ['config', 'cedenteService', '$rootScope', '$scope', '$state', '$mdDialog'];

    function CedenteDialogCtrl(config, cedenteService, $rootScope, $scope, $state, $mdDialog) {

        var vm = this;
        vm.init = init;
        vm.getData = getData;
        vm.cedente = {
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
            vm.cedente.data = [];
            getData();
        }

        function getData(params) {
            params = params || {};

            vm.filter = vm.filter || {};
            vm.filter.page = vm.cedente.page;
            vm.filter.limit = vm.cedente.limit;

            if (params.reset) {
                vm.cedente.data = [];
            }

            vm.cedente.promise = cedenteService.get(vm.filter)
                .then(function success(response) {
                    console.info('success', response);
                    vm.cedente.total = response.recordCount;
                    vm.cedente.data = vm.cedente.data.concat(response.query);
                }, function error(response) {
                    console.error('error', response);
                });
        }

        function itemClick(item) {
            $mdDialog.hide(item);
        }

        function cancel(item) {
            $mdDialog.cancel();
        }
    }
})();