(function() {
    'use strict';

    angular.module('seeawayApp').controller('SacadoCtrl', SacadoCtrl);

    SacadoCtrl.$inject = ['config', 'sacadoService', '$rootScope', '$scope', '$state', '$mdDialog'];

    function SacadoCtrl(config, sacadoService, $rootScope, $scope, $state, $mdDialog) {

        var vm = this;
        vm.init = init;
        vm.getData = getData;
        // vm.create = create;
        vm.update = update;
        // vm.remove = remove;
        vm.sacado = {
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
            vm.sacado.data = [];
            getData();
        }

        function getData(params) {

            params = params || {};

            vm.filter = vm.filter || {};
            vm.filter.page = vm.sacado.page;
            vm.filter.limit = vm.sacado.limit;

            if (params.reset) {
                vm.sacado.data = [];
            }

            vm.sacado.promise = sacadoService.get(vm.filter)
                .then(function success(response) {
                    //console.info('success', response);
                    vm.sacado.total = response.recordCount;
                    vm.sacado.data = vm.sacado.data.concat(response.query);
                }, function error(response) {
                    console.error('error', response);
                });
        }

        //function create() {
        //    $state.go('sacado-form');
        //}

        function update(id) {
            $state.go('sacado-form', id);
        }

    }
})();