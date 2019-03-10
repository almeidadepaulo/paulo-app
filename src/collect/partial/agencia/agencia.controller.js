(function() {
    'use strict';

    angular.module('seeawayApp').controller('AgenciaCtrl', AgenciaCtrl);

    AgenciaCtrl.$inject = ['config', 'agenciaService', '$rootScope', '$scope', '$state', '$mdDialog'];

    function AgenciaCtrl(config, agenciaService, $rootScope, $scope, $state, $mdDialog) {

        var vm = this;
        vm.init = init;
        vm.getData = getData;
        vm.create = create;
        vm.update = update;
        vm.remove = remove;
        vm.agencia = {
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
            vm.agencia.data = [];
            getData();
        }

        function getData(params) {

            params = params || {};

            vm.filter = vm.filter || {};
            vm.filter.page = vm.agencia.page;
            vm.filter.limit = vm.agencia.limit;

            if (params.reset) {
                vm.agencia.data = [];
            }

            vm.agencia.promise = agenciaService.get(vm.filter)
                .then(function success(response) {
                    //console.info('success', response);
                    vm.agencia.total = response.recordCount;
                    vm.agencia.data = vm.agencia.data.concat(response.query);
                }, function error(response) {
                    console.error('error', response);
                });
        }

        function create() {
            $state.go('agencia-form');
        }

        function update(id) {
            $state.go('agencia-form', id);
        }

        function remove() {

            var confirm = $mdDialog.confirm()
                .title('ATENÇÃO')
                .textContent('Deseja realmente remover o(s) item(ns) selecionado(s)?')
                .targetEvent(event)
                .ok('SIM')
                .cancel('NÃO');

            $mdDialog.show(confirm).then(function() {
                agenciaService.remove(vm.agencia.selected)
                    .then(function success(response) {
                        if (response.success) {
                            $('.md-selected').remove();
                            vm.agencia.selected = [];
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