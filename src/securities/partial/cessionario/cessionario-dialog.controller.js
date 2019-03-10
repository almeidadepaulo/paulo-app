(function() {
    'use strict';

    angular.module('seeawayApp').controller('CessionarioDialogCtrl', CessionarioDialogCtrl);

    CessionarioDialogCtrl.$inject = ['config', 'cessionarioService', '$rootScope', '$scope', '$state', '$mdDialog'];

    function CessionarioDialogCtrl(config, cessionarioService, $rootScope, $scope, $state, $mdDialog) {

        var vm = this;
        vm.init = init;
        vm.getData = getData;
        vm.cessionario = {
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
            vm.cessionario.data = [];
            getData();
        }

        function getData(params) {
            params = params || {};

            vm.filter = vm.filter || {};
            vm.filter.page = vm.cessionario.page;
            vm.filter.limit = vm.cessionario.limit;

            if (params.reset) {
                vm.cessionario.data = [];
            }

            vm.cessionario.promise = cessionarioService.get(vm.filter)
                .then(function success(response) {
                    console.info('success', response);
                    vm.cessionario.total = response.recordCount;
                    vm.cessionario.data = vm.cessionario.data.concat(response.query);
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