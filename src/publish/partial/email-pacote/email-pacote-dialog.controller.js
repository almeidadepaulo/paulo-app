(function() {
    'use strict';

    angular.module('seeawayApp').controller('EmailPacoteDialogCtrl', EmailPacoteDialogCtrl);

    EmailPacoteDialogCtrl.$inject = ['config', 'emailPacoteService', '$rootScope', '$scope', '$state', '$mdDialog',
        'ignorePacotes'
    ];

    function EmailPacoteDialogCtrl(config, emailPacoteService, $rootScope, $scope, $state, $mdDialog,
        ignorePacotes) {

        var vm = this;
        vm.init = init;
        vm.getData = getData;
        vm.emailPacote = {
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
            vm.emailPacote.data = [];
            getData();
        }

        function getData(params) {
            params = params || {};

            vm.filter = vm.filter || {};
            vm.filter.page = vm.emailPacote.page;
            vm.filter.limit = vm.emailPacote.limit;
            vm.filter.ignorePacotes = ignorePacotes;

            if (params.reset) {
                vm.emailPacote.data = [];
            }

            vm.emailPacote.promise = emailPacoteService.get(vm.filter)
                .then(function success(response) {
                    //console.info('success', response);
                    vm.emailPacote.total = response.recordCount;
                    vm.emailPacote.data = vm.emailPacote.data.concat(response.query);
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