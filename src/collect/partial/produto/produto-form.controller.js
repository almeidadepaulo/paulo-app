(function() {
    'use strict';

    angular.module('seeawayApp').controller('ProdutoFormCtrl', ProdutoFormCtrl);

    ProdutoFormCtrl.$inject = ['$state', '$stateParams', '$mdDialog', 'produtoService', 'getData'];

    function ProdutoFormCtrl($state, $stateParams, $mdDialog, produtoService, getData) {

        var vm = this;
        vm.init = init;
        vm.produto = {};
        vm.getData = getData;
        vm.removeById = removeById;
        vm.cancel = cancel;
        vm.save = save;

        function init() {
            if ($stateParams.id) {
                vm.action = 'update';
                vm.produto = vm.getData;
            } else {
                vm.action = 'create';
            }
        }

        function removeById(event) {
            var confirm = $mdDialog.confirm()
                .title('ATENÇÃO')
                .textContent('Deseja realmente remover este registro?')
                .targetEvent(event)
                .ok('SIM')
                .cancel('NÃO');

            $mdDialog.show(confirm).then(function() {
                produtoService.removeById($stateParams.id)
                    .then(function success(response) {
                        console.info('success', response);
                        $state.go('produto');
                    }, function error(response) {
                        console.error('error', response);
                    });
            }, function() {
                // cancel
            });
        }

        function cancel() {
            $state.go('produto');
        }

        function save() {

            if ($stateParams.id) {
                //update
                produtoService.update($stateParams.id, vm.produto)
                    .then(function success(response) {
                        console.info('success', response);
                        $state.go('produto');
                    }, function error(response) {
                        console.error('error', response);
                    });
            } else {
                // create
                produtoService.create(vm.produto)
                    .then(function success(response) {
                        if (response.success) {
                            $state.go('produto');
                        }
                        console.info('success', response);
                    }, function error(response) {
                        console.error('error', response);
                    });
            }
        }
    }
})();