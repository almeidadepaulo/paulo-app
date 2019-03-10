(function() {
    'use strict';

    angular.module('seeawayApp').controller('SmsResumoCpfCtrl', SmsResumoCpfCtrl);

    SmsResumoCpfCtrl.$inject = ['config', 'smsResumoCpfService', '$rootScope', '$scope', '$state', '$mdDialog'];

    function SmsResumoCpfCtrl(config, smsResumoCpfService, $rootScope, $scope, $state, $mdDialog) {

        var vm = this;
        vm.init = init;
        vm.getData = getData;
        vm.smsResumoCpf = {
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
            vm.filter.MG004_DT_MOVTO = null;
            getData({ reset: true });
        }

        function pagination(page, limit) {
            vm.smsResumoCpf.data = [];
            getData();
        }

        function getData(params) {

            params = params || {};

            vm.filter = vm.filter || {};
            vm.filter.page = vm.smsResumoCpf.page;
            vm.filter.limit = vm.smsResumoCpf.limit;

            if (params.reset) {
                vm.smsResumoCpf.data = [];
            }

            vm.smsResumoCpf.promise = smsResumoCpfService.get(vm.filter)
                .then(function success(response) {
                    //console.info('success', response);
                    vm.smsResumoCpf.total = response.recordCount;
                    vm.smsResumoCpf.data = vm.smsResumoCpf.data.concat(response.query);
                }, function error(response) {
                    console.error('error', response);
                });
        }

    }

})();