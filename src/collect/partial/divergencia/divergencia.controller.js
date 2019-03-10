(function() {
    'use strict';

    angular.module('seeawayApp').controller('DivergenciaCtrl', DivergenciaCtrl);

    DivergenciaCtrl.$inject = ['config', 'divergenciaService', '$rootScope', '$scope', '$state', '$mdDialog'];

    function DivergenciaCtrl(config, divergenciaService, $rootScope, $scope, $state, $mdDialog) {

        var vm = this;
        vm.init = init;
        vm.getData = getData;
        // vm.create = create;
        vm.update = update;
        // vm.remove = remove;
        vm.divergencia = {
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
            vm.divergencia.data = [];
            getData();
        }

        function getData(params) {

            params = params || {};

            vm.filter = vm.filter || {};
            vm.filter.page = vm.divergencia.page;
            vm.filter.limit = vm.divergencia.limit;

            if (params.reset) {
                vm.divergencia.data = [];
            }

            vm.divergencia.promise = divergenciaService.get(vm.filter)
                .then(function success(response) {
                    //console.info('success', response);
                    vm.divergencia.total = response.recordCount;
                    vm.divergencia.data = vm.divergencia.data.concat(response.query);
                }, function error(response) {
                    console.error('error', response);
                });
        }

        //function create() {
        //    $state.go('divergencia-form');
        //}

        function update(id) {
            $state.go('divergencia-form', id);
        }

    }
})();