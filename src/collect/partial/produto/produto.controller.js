(function() {
    'use strict';

    angular.module('seeawayApp').controller('ProdutoCtrl', ProdutoCtrl);

    ProdutoCtrl.$inject = ['config', 'produtoService', '$rootScope', '$scope', '$state', '$mdDialog'];

    function ProdutoCtrl(config, produtoService, $rootScope, $scope, $state, $mdDialog) {

        var vm = this;
        vm.init = init;
        vm.getData = getData;
        vm.create = create;
        vm.update = update;
        vm.remove = remove;
        vm.produto = {
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
            vm.produto.data = [];
            getData();
        }

        function getData(params) {

            params = params || {};

            vm.filter = vm.filter || {};
            vm.filter.page = vm.produto.page;
            vm.filter.limit = vm.produto.limit;

            if (params.reset) {
                vm.produto.data = [];
            }

            vm.produto.promise = produtoService.get(vm.filter)
                .then(function success(response) {
                    //console.info('success', response);
                    vm.produto.total = response.recordCount;
                    vm.produto.data = vm.produto.data.concat(response.query);
                }, function error(response) {
                    console.error('error', response);
                });
        }

        function create() {
            $state.go('produto-form');
        }

        function update(id) {
            $state.go('produto-form', id);
        }

        function remove() {

            var confirm = $mdDialog.confirm()
                .title('ATENÇÃO')
                .textContent('Deseja realmente remover o(s) item(ns) selecionado(s)?')
                .targetEvent(event)
                .ok('SIM')
                .cancel('NÃO');

            $mdDialog.show(confirm).then(function() {
                produtoService.remove(vm.produto.selected)
                    .then(function success(response) {
                        if (response.success) {
                            $('.md-selected').remove();
                            vm.produto.selected = [];
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