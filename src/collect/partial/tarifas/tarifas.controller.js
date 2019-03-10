(function() {
    'use strict';

    angular.module('seeawayApp').controller('TarifasCtrl', TarifasCtrl);

    TarifasCtrl.$inject = ['config', 'tarifasService', '$rootScope', '$scope', '$state', '$mdDialog'];

    function TarifasCtrl(config, tarifasService, $rootScope, $scope, $state, $mdDialog) {

        var vm = this;
        vm.init = init;
        vm.getData = getData;
        vm.create = create;
        vm.update = update;
        vm.remove = remove;
        vm.tarifas = {
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
            vm.tarifas.data = [];
            getData();
        }

        function getData(params) {

            params = params || {};

            vm.filter = vm.filter || {};
            vm.filter.page = vm.tarifas.page;
            vm.filter.limit = vm.tarifas.limit;

            if (params.reset) {
                vm.tarifas.data = [];
            }

            vm.tarifas.promise = tarifasService.get(vm.filter)
                .then(function success(response) {
                    //console.info('success', response);
                    vm.tarifas.total = response.recordCount;
                    vm.tarifas.data = vm.tarifas.data.concat(response.query);
                }, function error(response) {
                    console.error('error', response);
                });
        }

        function create() {
            $state.go('tarifas-form');
        }

        function update(id) {
            $state.go('tarifas-form', id);
        }

        function remove() {

            var confirm = $mdDialog.confirm()
                .title('ATENÇÃO')
                .textContent('Deseja realmente remover o(s) item(ns) selecionado(s)?')
                .targetEvent(event)
                .ok('SIM')
                .cancel('NÃO');

            $mdDialog.show(confirm).then(function() {
                tarifasService.remove(vm.tarifas.selected)
                    .then(function success(response) {
                        if (response.success) {
                            $('.md-selected').remove();
                            vm.tarifas.selected = [];
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