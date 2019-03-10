(function() {
    'use strict';

    angular.module('seeawayApp').controller('EmailVariavelCtrl', EmailVariavelCtrl);

    EmailVariavelCtrl.$inject = ['config', 'emailVariavelService', '$rootScope', '$scope', '$state', '$mdDialog'];

    function EmailVariavelCtrl(config, emailVariavelService, $rootScope, $scope, $state, $mdDialog) {

        var vm = this;
        vm.init = init;
        vm.getData = getData;
        vm.emailVariavel = {
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
            vm.emailVariavel.data = [];
            getData();
        }

        function getData(params) {

            params = params || {};

            vm.filter = vm.filter || {};
            vm.filter.page = vm.emailVariavel.page;
            vm.filter.limit = vm.emailVariavel.limit;

            if (params.reset) {
                vm.emailVariavel.data = [];
            }

            vm.emailVariavel.promise = emailVariavelService.get(vm.filter)
                .then(function success(response) {
                    //console.info('success', response);
                    vm.emailVariavel.total = response.recordCount;
                    vm.emailVariavel.data = vm.emailVariavel.data.concat(response.query);
                }, function error(response) {
                    console.error('error', response);
                });
        }

    }

})();