(function() {
    'use strict';

    angular.module('seeawayApp').controller('CessionarioCtrl', CessionarioCtrl);

    CessionarioCtrl.$inject = ['config', 'cessionarioService', '$rootScope', '$scope', '$state', '$mdDialog'];

    function CessionarioCtrl(config, cessionarioService, $rootScope, $scope, $state, $mdDialog) {

        var vm = this;
        vm.init = init;
        vm.getData = getData;
        vm.create = create;
        vm.update = update;
        vm.remove = remove;
        vm.cessionario = {
            limit: 10,
            page: 1,
            selected: [],
            order: '',
            data: [],
            pagination: pagination,
            total: 0
        };

        function init(event) {
            getData({ reset: true });
        }

        // $on
        // https://docs.angularjs.org/api/ng/type/$rootScope.Scope
        $scope.$on('broadcastTest', function() {
            console.info('broadcastTest!');
            //getData();
        });

        function pagination(page, limit) {
            vm.cessionario.data = [];
            getData();
        }

        function getData(params) {
            params = params || {};

            vm.filter = vm.filter || {};
            vm.filter.page = vm.cessionario.page;
            vm.filter.limit = vm.cessionario.limit;

            if (params.reset) {
                vm.cessionario.data = [];
            }

            vm.cessionario.promise = cessionarioService.get(vm.filter, false)
                .then(function success(response) {
                    console.info('success', response);
                    vm.cessionario.total = response.recordCount;
                    vm.cessionario.data = vm.cessionario.data.concat(response.query);
                }, function error(response) {
                    console.error('error', response);
                });
        }

        function create() {
            $state.go('cessionario-form');
        }

        function update(id) {
            $state.go('cessionario-form', id);
        }

        function remove() {
            var confirm = $mdDialog.confirm()
                .title('ATENÇÃO')
                .textContent('Deseja realmente remover o(s) item(ns) selecionado(s)?')
                .targetEvent(event)
                .ok('SIM')
                .cancel('NÃO');

            $mdDialog.show(confirm).then(function() {
                cessionarioService.remove(vm.cessionario.selected)
                    .then(function success(response) {
                        if (response.success) {
                            $('.md-selected').remove();
                            vm.cessionario.selected = [];
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