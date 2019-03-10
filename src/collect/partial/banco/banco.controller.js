(function() {
    'use strict';

    angular.module('seeawayApp').controller('BancoCtrl', BancoCtrl);

    BancoCtrl.$inject = ['config', 'bancoService', '$rootScope', '$scope', '$state', '$mdDialog'];

    function BancoCtrl(config, bancoService, $rootScope, $scope, $state, $mdDialog) {

        var vm = this;
        vm.init = init;
        vm.getData = getData;
        vm.create = create;
        vm.update = update;
        vm.remove = remove;
        vm.banco = {
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
            vm.banco.data = [];
            getData();
        }

        function getData(params) {

            params = params || {};

            vm.filter = vm.filter || {};
            vm.filter.page = vm.banco.page;
            vm.filter.limit = vm.banco.limit;

            if (params.reset) {
                vm.banco.data = [];
            }

            vm.banco.promise = bancoService.get(vm.filter)
                .then(function success(response) {
                    //console.info('success', response);
                    vm.banco.total = response.recordCount;
                    vm.banco.data = vm.banco.data.concat(response.query);
                }, function error(response) {
                    console.error('error', response);
                });
        }

        function create() {
            $state.go('banco-form');
        }

        function update(id) {
            $state.go('banco-form', id);
        }

        function remove() {

            var confirm = $mdDialog.confirm()
                .title('ATENÇÃO')
                .textContent('Deseja realmente remover o(s) item(ns) selecionado(s)?')
                .targetEvent(event)
                .ok('SIM')
                .cancel('NÃO');

            $mdDialog.show(confirm).then(function() {
                bancoService.remove(vm.banco.selected)
                    .then(function success(response) {
                        if (response.success) {
                            $('.md-selected').remove();
                            vm.banco.selected = [];
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