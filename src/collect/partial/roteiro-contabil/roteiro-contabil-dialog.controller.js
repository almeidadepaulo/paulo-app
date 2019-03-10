(function() {
    'use strict';

    angular.module('seeawayApp').controller('RoteiroContabilDialogCtrl', RoteiroContabilDialogCtrl);

    RoteiroContabilDialogCtrl.$inject = ['config', 'roteiroContabilService', '$rootScope', '$scope', '$state', '$mdDialog'];

    function RoteiroContabilDialogCtrl(config, roteiroContabilService, $rootScope, $scope, $state, $mdDialog,
        ignorePacotes) {

        var vm = this;
        vm.init = init;
        vm.getData = getData;
        vm.roteiroContabil = {
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
            vm.roteiroContabil.data = [];
            getData();
        }

        function getData(params) {
            params = params || {};

            vm.filter = vm.filter || {};
            vm.filter.page = vm.roteiroContabil.page;
            vm.filter.limit = vm.roteiroContabil.limit;
            vm.filter.ignorePacotes = ignorePacotes;

            if (params.reset) {
                vm.roteiroContabil.data = [];
            }

            vm.roteiroContabil.promise = roteiroContabilService.get(vm.filter)
                .then(function success(response) {
                    //console.info('success', response);
                    vm.roteiroContabil.total = response.recordCount;
                    vm.roteiroContabil.data = vm.roteiroContabil.data.concat(response.query);
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