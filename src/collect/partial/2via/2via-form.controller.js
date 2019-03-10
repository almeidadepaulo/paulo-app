(function() {
    'use strict';

    angular.module('seeawayApp').controller('SegundaviaFormCtrl', SegundaviaFormCtrl);

    SegundaviaFormCtrl.$inject = ['$state', '$stateParams', '$mdDialog', 'segundaViaService', 'getData'];

    function SegundaviaFormCtrl($state, $stateParams, $mdDialog, segundaViaService, getData) {

        var vm = this;
        vm.init = init;
        
        vm.segundaVia = {};
        vm.getData = getData;
        vm.removeById = removeById;
        vm.cancel = cancel;
        vm.save = save;

        function init() {
            if ($stateParams.id) {
                vm.action = 'update';
                vm.segundaVia = vm.getData;
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
                segundaViaService.removeById($stateParams.id)
                    .then(function success(response) {
                        console.info('success', response);
                        $state.go('2via');
                    }, function error(response) {
                        console.error('error', response);
                    });
            }, function() {
                // cancel
            });
        }

        function cancel() {
            $state.go('2via');
        }

        function save() {

            if ($stateParams.id) {
                //update
                segundaViaService.update($stateParams.id, vm.segundaVia)
                    .then(function success(response) {
                        console.info('success', response);
                        $state.go('2via');
                    }, function error(response) {
                        console.error('error', response);
                    });
            } else {
                // create
                segundaViaService.create(vm.segundaVia)
                    .then(function success(response) {
                        if (response.success) {
                            $state.go('2via');
                        }
                        console.info('success', response);
                    }, function error(response) {
                        console.error('error', response);
                    });
            }
        }
    }
})();