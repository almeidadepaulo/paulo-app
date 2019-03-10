(function() {
    'use strict';

    angular.module('seeawayApp').controller('SmsPacoteDialogCtrl', SmsPacoteDialogCtrl);

    SmsPacoteDialogCtrl.$inject = ['config', 'smsPacoteService', '$rootScope', '$scope', '$state', '$mdDialog',
        'ignorePacotes'
    ];

    function SmsPacoteDialogCtrl(config, smsPacoteService, $rootScope, $scope, $state, $mdDialog,
        ignorePacotes) {

        var vm = this;
        vm.init = init;
        vm.getData = getData;
        vm.smsPacote = {
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
            vm.smsPacote.data = [];
            getData();
        }

        function getData(params) {
            params = params || {};

            vm.filter = vm.filter || {};
            vm.filter.page = vm.smsPacote.page;
            vm.filter.limit = vm.smsPacote.limit;
            vm.filter.ignorePacotes = ignorePacotes;

            if (params.reset) {
                vm.smsPacote.data = [];
            }

            vm.smsPacote.promise = smsPacoteService.get(vm.filter)
                .then(function success(response) {
                    //console.info('success', response);
                    vm.smsPacote.total = response.recordCount;
                    vm.smsPacote.data = vm.smsPacote.data.concat(response.query);
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