(function() {
    'use strict';

    angular.module('seeawayApp').controller('EmailCodigoDialogCtrl', EmailCodigoDialogCtrl);

    EmailCodigoDialogCtrl.$inject = ['config', 'emailCodigoService', '$rootScope', '$scope', '$state', '$mdDialog'];

    function EmailCodigoDialogCtrl(config, emailCodigoService, $rootScope, $scope, $state, $mdDialog) {

        var vm = this;
        vm.init = init;
        vm.getData = getData;
        vm.emailCodigo = {
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
            vm.emailCodigo.data = [];
            getData();
        }

        function getData(params) {
            params = params || {};

            vm.filter = vm.filter || {};
            vm.filter.page = vm.emailCodigo.page;
            vm.filter.limit = vm.emailCodigo.limit;

            if (params.reset) {
                vm.emailCodigo.data = [];
            }

            vm.emailCodigo.promise = emailCodigoService.get(vm.filter)
                .then(function success(response) {
                    //console.info('success', response);
                    vm.emailCodigo.total = response.recordCount;
                    vm.emailCodigo.data = vm.emailCodigo.data.concat(response.query);
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