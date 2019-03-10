(function() {
    'use strict';

    angular.module('seeawayApp').controller('SmsCodigoDialogCtrl', SmsCodigoDialogCtrl);

    SmsCodigoDialogCtrl.$inject = ['config', 'smsCodigoService', '$rootScope', '$scope', '$state', '$mdDialog'];

    function SmsCodigoDialogCtrl(config, smsCodigoService, $rootScope, $scope, $state, $mdDialog) {

        var vm = this;
        vm.init = init;
        vm.getData = getData;
        vm.smsCodigo = {
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
            vm.smsCodigo.data = [];
            getData();
        }

        function getData(params) {
            params = params || {};

            vm.filter = vm.filter || {};
            vm.filter.page = vm.smsCodigo.page;
            vm.filter.limit = vm.smsCodigo.limit;

            if (params.reset) {
                vm.smsCodigo.data = [];
            }

            vm.smsCodigo.promise = smsCodigoService.get(vm.filter)
                .then(function success(response) {
                    //console.info('success', response);
                    vm.smsCodigo.total = response.recordCount;
                    vm.smsCodigo.data = vm.smsCodigo.data.concat(response.query);
                }, function error(response) {
                    console.error('error', response);
                });
        }

        function itemClick(item) {
            item.id = item.MG055_CD_CODSMS;
            item.name = item.MG055_DS_CODSMS;
            $mdDialog.hide(item);
        }

        function cancel() {
            $mdDialog.cancel();
        }
    }
})();