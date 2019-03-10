(function() {
    'use strict';

    angular.module('seeawayApp').controller('SmsVariavelCtrl', SmsVariavelCtrl);

    SmsVariavelCtrl.$inject = ['config', 'smsVariavelService', '$rootScope', '$scope', '$state', '$mdDialog'];

    function SmsVariavelCtrl(config, smsVariavelService, $rootScope, $scope, $state, $mdDialog) {

        var vm = this;
        vm.init = init;
        vm.getData = getData;
        vm.smsVariavel = {
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
            getData({ reset: true });
        }

        function pagination(page, limit) {
            vm.smsVariavel.data = [];
            getData();
        }

        function getData(params) {

            params = params || {};

            vm.filter = vm.filter || {};
            vm.filter.page = vm.smsVariavel.page;
            vm.filter.limit = vm.smsVariavel.limit;

            if (params.reset) {
                vm.smsVariavel.data = [];
            }

            vm.smsVariavel.promise = smsVariavelService.get(vm.filter)
                .then(function success(response) {
                    //console.info('success', response);
                    vm.smsVariavel.total = response.recordCount;
                    vm.smsVariavel.data = vm.smsVariavel.data.concat(response.query);
                }, function error(response) {
                    console.error('error', response);
                });
        }

    }

})();