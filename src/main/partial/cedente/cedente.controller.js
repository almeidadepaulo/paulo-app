(function() {
    'use strict';

    angular.module('seeawayApp').controller('CedenteCtrl', CedenteCtrl);

    CedenteCtrl.$inject = ['config', 'cedenteService', '$rootScope', '$scope', '$state', '$mdDialog'];

    function CedenteCtrl(config, cedenteService, $rootScope, $scope, $state, $mdDialog) {

        var vm = this;
        vm.init = init;
        vm.getData = getData;
        vm.create = create;
        vm.update = update;
        vm.remove = remove;
        vm.cedente = {
            limit: 10,
            page: 1,
            selected: [],
            order: '',
            data: [],
            pagination: pagination,
            total: 0
        };
        vm.cedenteContato = {
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
            vm.cedente.data = [];
            getData();
        }

        function getData(params) {
            params = params || {};

            vm.filter = vm.filter || {};
            vm.filter.page = vm.cedente.page;
            vm.filter.limit = vm.cedente.limit;

            if (params.reset) {
                vm.cedente.data = [];
            }

            vm.cedente.promise = cedenteService.get(vm.filter, false)
                .then(function success(response) {

                    if ($rootScope.globals.currentUser.perfilTipo === 3) {
                        update(response.query[0]);
                    } else {
                        vm.complete = true;
                        vm.cedente.total = response.recordCount;
                        vm.cedente.data = vm.cedente.data.concat(response.query);
                    }
                }, function error(response) {
                    console.error('error', response);
                });
        }

        function create() {
            $state.go('cedente-form');
        }

        function update(id) {
            $state.go('cedente-form', id);
        }

        function remove() {
            var confirm = $mdDialog.confirm()
                .title('ATENÇÃO')
                .textContent('Deseja realmente remover o(s) item(ns) selecionado(s)?')
                .targetEvent(event)
                .ok('SIM')
                .cancel('NÃO');

            $mdDialog.show(confirm).then(function() {
                cedenteService.remove(vm.cedente.selected)
                    .then(function success(response) {
                        if (response.success) {
                            $('.md-selected').remove();
                            vm.cedente.selected = [];
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