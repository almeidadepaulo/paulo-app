(function() {
    'use strict';

    angular.module('seeawayApp').controller('EmailResumoCtrl', EmailResumoCtrl);

    EmailResumoCtrl.$inject = ['config', 'emailResumoService', '$rootScope', '$scope', '$state', '$mdDialog'];

    function EmailResumoCtrl(config, emailResumoService, $rootScope, $scope, $state, $mdDialog) {

        var vm = this;
        vm.init = init;
        vm.getData = getData;
        vm.emailResumo = {
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
            vm.filter.EM003_DT_MOVTO = '';
            getData({ reset: true });
        }

        function pagination(page, limit) {
            vm.emailResumo.data = [];
            getData();
        }

        function getData(params) {

            params = params || {};

            vm.filter.page = vm.emailResumo.page;
            vm.filter.limit = vm.emailResumo.limit;

            if (params.reset) {
                vm.emailResumo.data = [];
            }

            vm.emailResumo.promise = emailResumoService.get(vm.filter)
                .then(function success(response) {
                    //console.info('success', response);
                    vm.emailResumo.total = response.recordCount;
                    vm.emailResumo.data = vm.emailResumo.data.concat(response.query);
                }, function error(response) {
                    console.error('error', response);
                });
        }

    }

})();