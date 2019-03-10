(function() {
    'use strict';

    angular.module('seeawayApp').controller('EmailResumoCpfCtrl', EmailResumoCpfCtrl);

    EmailResumoCpfCtrl.$inject = ['config', 'emailResumoCpfService', '$rootScope', '$scope', '$state', '$mdDialog'];

    function EmailResumoCpfCtrl(config, emailResumoCpfService, $rootScope, $scope, $state, $mdDialog) {

        var vm = this;
        vm.init = init;
        vm.getData = getData;
        vm.emailResumoCpf = {
            limit: 10,
            page: 1,
            selected: [],
            order: '',
            data: [],
            pagination: pagination,
            total: 0
        };

        // $on
        // https://docs.angularjs.org/api/ng/type/$rootScope.Scope
        $scope.$on('broadcastTest', function() {
            console.info('broadcastTest!');
            //getData();
        });

        function init() {
            vm.filter = vm.filter || {};
            vm.filter.EM004_DT_MOVTO = '';
            getData({ reset: true });
        }

        function pagination(page, limit) {
            vm.emailResumoCpf.data = [];
            getData();
        }

        function getData(params) {

            params = params || {};

            vm.filter = vm.filter || {};
            vm.filter.page = vm.emailResumoCpf.page;
            vm.filter.limit = vm.emailResumoCpf.limit;

            if (params.reset) {
                vm.emailResumoCpf.data = [];
            }

            vm.emailResumoCpf.promise = emailResumoCpfService.get(vm.filter)
                .then(function success(response) {
                    //console.info('success', response);
                    vm.emailResumoCpf.total = response.recordCount;
                    vm.emailResumoCpf.data = vm.emailResumoCpf.data.concat(response.query);
                }, function error(response) {
                    console.error('error', response);
                });
        }

    }

})();