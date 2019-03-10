(function() {
    'use strict';

    angular.module('seeawayApp').controller('CarteiraFormCtrl', CarteiraFormCtrl);

    CarteiraFormCtrl.$inject = ['$state', '$stateParams', '$mdDialog', 'carteiraService', 'getData'];

    function CarteiraFormCtrl($state, $stateParams, $mdDialog, carteiraService, getData) {

        var vm = this;
        vm.init = init;
        vm.carteira = {};
        vm.getData = getData;
        vm.removeById = removeById;
        vm.cancel = cancel;
        vm.save = save;

        function init() {
            if ($stateParams.id) {
                vm.action = 'update';
                vm.carteira = vm.getData;
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
                carteiraService.removeById($stateParams.id)
                    .then(function success(response) {
                        console.info('success', response);
                        $state.go('carteira');
                    }, function error(response) {
                        console.error('error', response);
                    });
            }, function() {
                // cancel
            });
        }

        function cancel() {
            $state.go('carteira');
        }

        function save() {

            if ($stateParams.id) {
                //update
                carteiraService.update($stateParams.id, vm.carteira)
                    .then(function success(response) {
                        console.info('success', response);
                        $state.go('carteira');
                    }, function error(response) {
                        console.error('error', response);
                    });
            } else {
                // create
                carteiraService.create(vm.carteira)
                    .then(function success(response) {
                        if (response.success) {
                            $state.go('carteira');
                        }
                        console.info('success', response);
                    }, function error(response) {
                        console.error('error', response);
                    });
            }
        }
    }
})();