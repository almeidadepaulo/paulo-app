(function() {
    'use strict';

    angular.module('seeawayApp').controller('ContaCtrl', ContaCtrl);

    ContaCtrl.$inject = ['config', 'contaService', '$rootScope', '$scope', '$state', '$mdDialog'];

    function ContaCtrl(config, contaService, $rootScope, $scope, $state, $mdDialog) {

        var vm = this;
        vm.init = init;
        vm.getData = getData;
        vm.create = create;
        vm.update = update;
        vm.remove = remove;
        vm.conta = {
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
            vm.conta.data = [];
            getData();
        }

        function getData(params) {

            params = params || {};

            vm.filter = vm.filter || {};
            vm.filter.page = vm.conta.page;
            vm.filter.limit = vm.conta.limit;

            if (params.reset) {
                vm.conta.data = [];
            }

            vm.conta.promise = contaService.get(vm.filter)
                .then(function success(response) {
                    //console.info('success', response);
                    vm.conta.total = response.recordCount;
                    vm.conta.data = vm.conta.data.concat(response.query);
                }, function error(response) {
                    console.error('error', response);
                });
        }

        function create() {
            $state.go('conta-form');
        }

        function update(id) {
            $state.go('conta-form', id);
        }

        function remove() {

            var confirm = $mdDialog.confirm()
                .title('ATENÇÃO')
                .textContent('Deseja realmente remover o(s) item(ns) selecionado(s)?')
                .targetEvent(event)
                .ok('SIM')
                .cancel('NÃO');

            $mdDialog.show(confirm).then(function() {
                contaService.remove(vm.conta.selected)
                    .then(function success(response) {
                        if (response.success) {
                            $('.md-selected').remove();
                            vm.conta.selected = [];
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