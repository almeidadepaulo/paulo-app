(function() {
    'use strict';

    angular.module('seeawayApp').controller('RoteiroContabilCtrl', RoteiroContabilCtrl);

    RoteiroContabilCtrl.$inject = ['config', 'roteiroContabilService', '$rootScope', '$scope', '$state', '$mdDialog'];

    function RoteiroContabilCtrl(config, roteiroContabilService, $rootScope, $scope, $state, $mdDialog) {

        var vm = this;
        vm.init = init;
        vm.getData = getData;
        vm.create = create;
        vm.update = update;
        vm.remove = remove;
        vm.roteiroContabil = {
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
            vm.roteiroContabil.data = [];
            getData();
        }

        function getData(params) {

            params = params || {};

            vm.filter = vm.filter || {};
            vm.filter.page = vm.roteiroContabil.page;
            vm.filter.limit = vm.roteiroContabil.limit;

            if (params.reset) {
                vm.roteiroContabil.data = [];
            }

            vm.roteiroContabil.promise = roteiroContabilService.get(vm.filter)
                .then(function success(response) {
                    //console.info('success', response);
                    vm.roteiroContabil.total = response.recordCount;
                    vm.roteiroContabil.data = vm.roteiroContabil.data.concat(response.query);
                }, function error(response) {
                    console.error('error', response);
                });
        }

        function create() {
            $state.go('roteiro-contabil-form');
        }

        function update(id) {
            $state.go('roteiro-contabil-form', id);
        }

        function remove() {

            var confirm = $mdDialog.confirm()
                .title('ATENÇÃO')
                .textContent('Deseja realmente remover o(s) item(ns) selecionado(s)?')
                .targetEvent(event)
                .ok('SIM')
                .cancel('NÃO');

            $mdDialog.show(confirm).then(function() {
                roteiroContabilService.remove(vm.roteiroContabil.selected)
                    .then(function success(response) {
                        if (response.success) {
                            $('.md-selected').remove();
                            vm.roteiroContabil.selected = [];
                        }
                    }, function error(response) {
                        console.error('error', response);
                    });
            }, function() {
                // cancel
            });
        }
    }
})();