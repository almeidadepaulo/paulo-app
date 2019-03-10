(function() {
    'use strict';

    angular.module('seeawayApp').controller('ContratoFormCtrl', ContratoFormCtrl);

    ContratoFormCtrl.$inject = ['$state', '$stateParams', '$mdDialog', 'contratoService', 'getData'];

    function ContratoFormCtrl($state, $stateParams, $mdDialog, contratoService, getData) {

        var vm = this;
        vm.init = init;
        vm.contrato = {};
        vm.getData = getData;
        vm.removeById = removeById;
        vm.cancel = cancel;
        vm.save = save;

        function init() {
            if ($stateParams.id) {
                vm.action = 'update';
                vm.contrato = vm.getData;
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
                contratoService.removeById($stateParams.id)
                    .then(function success(response) {
                        console.info('success', response);
                        $state.go('contrato');
                    }, function error(response) {
                        console.error('error', response);
                    });
            }, function() {
                // cancel
            });
        }

        function cancel() {
            $state.go('contrato');
        }

        function save() {

            if ($stateParams.id) {
                //update
                contratoService.update($stateParams.id, vm.contrato)
                    .then(function success(response) {
                        console.info('success', response);
                        $state.go('contrato');
                    }, function error(response) {
                        console.error('error', response);
                    });
            } else {
                // create
                contratoService.create(vm.contrato)
                    .then(function success(response) {
                        if (response.success) {
                            $state.go('contrato');
                        }
                        console.info('success', response);
                    }, function error(response) {
                        console.error('error', response);
                    });
            }
        }
    }
})();