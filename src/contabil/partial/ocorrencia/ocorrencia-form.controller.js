(function() {
    'use strict';

    angular.module('seeawayApp').controller('OcorrenciaFormCtrl', OcorrenciaFormCtrl);

    OcorrenciaFormCtrl.$inject = ['$state', '$stateParams', '$mdDialog', 'exampleService', 'getData'];

    function OcorrenciaFormCtrl($state, $stateParams, $mdDialog, exampleService, getData) {

        var vm = this;
        vm.init = init;
        vm.example = {};
        vm.getData = getData;
        vm.removeById = removeById;
        vm.cancel = cancel;
        vm.save = save;

        function init() {
            if ($stateParams.id !== null) {
                vm.action = 'update';
                vm.example = vm.getData.example;
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
                exampleService.removeById($stateParams.id)
                    .then(function success(response) {
                        console.info('success', response);
                        $state.go('ocorrencia');
                    }, function error(response) {
                        console.error('error', response);
                    });
            }, function() {
                // cancel
            });
        }

        function cancel() {
            $state.go('ocorrencia');
        }

        function save() {

            if ($stateParams.id) {
                //update
                //exampleService.update($stateParams.id, vm.example)
                //fake
                exampleService.update(0, vm.example)
                    .then(function success(response) {
                        console.info('success', response);
                        $state.go('ocorrencia');
                    }, function error(response) {
                        console.error('error', response);
                    });
            } else {
                // create
                exampleService.create(vm.example)
                    .then(function success(response) {
                        if (response.success) {
                            $state.go('ocorrencia');
                        }
                        console.info('success', response);
                    }, function error(response) {
                        console.error('error', response);
                    });
            }
        }
    }
})();