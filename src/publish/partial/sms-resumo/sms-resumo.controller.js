(function() {
    'use strict';

    angular.module('seeawayApp').controller('SmsResumoCtrl', SmsResumoCtrl);

    SmsResumoCtrl.$inject = ['config', 'smsResumoService', '$rootScope', '$scope', '$state', '$mdDialog'];

    function SmsResumoCtrl(config, smsResumoService, $rootScope, $scope, $state, $mdDialog) {

        var vm = this;
        vm.init = init;
        vm.getData = getData;
        vm.smsResumo = {
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
            vm.filter.MG003_DT_MOVTO = null;
            getData({ reset: true });
        }

        function pagination(page, limit) {
            vm.smsResumo.data = [];
            getData();
        }

        function getData(params) {

            params = params || {};

            vm.filter.page = vm.smsResumo.page;
            vm.filter.limit = vm.smsResumo.limit;

            if (params.reset) {
                vm.smsResumo.data = [];
            }

            vm.smsResumo.promise = smsResumoService.get(vm.filter)
                .then(function success(response) {
                    //console.info('success', response);
                    vm.smsResumo.total = response.recordCount;
                    vm.smsResumo.data = vm.smsResumo.data.concat(response.query);
                }, function error(response) {
                    console.error('error', response);
                });
        }

    }

})();