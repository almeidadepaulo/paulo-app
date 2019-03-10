(function() {
    'use strict';

    angular.module('seeawayApp').controller('CedenteFormCtrl', CedenteFormCtrl);

    CedenteFormCtrl.$inject = ['$state', '$stateParams', '$mdDialog', 'cedenteService', 'getData'];

    function CedenteFormCtrl($state, $stateParams, $mdDialog, cedenteService, getData) {

        var vm = this;
        vm.init = init;
        vm.cedente = {};
        vm.getData = getData;
        vm.removeById = removeById;
        vm.cancel = cancel;
        vm.save = save;

        function init() {
            if ($stateParams.id) {
                vm.action = 'update';

                vm.getData.CB053_NR_CPFCNPJ = String(vm.getData.CB053_NR_CPFCNPJ);
                vm.cedente = vm.getData;
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
                cedenteService.removeById($stateParams.id)
                    .then(function success(response) {
                        console.info('success', response);
                        $state.go('perfil-usuario', { tabIndex: 0 });
                    }, function error(response) {
                        console.error('error', response);
                    });
            }, function() {
                // cancel
            });
        }

        function cancel() {
            $state.go('perfil-usuario', { tabIndex: 0 });
        }

        function save() {

            if ($stateParams.id) {
                //update
                cedenteService.update($stateParams.id, vm.cedente)
                    .then(function success(response) {
                        console.info('success', response);
                        $state.go('perfil-usuario', { tabIndex: 0 });
                    }, function error(response) {
                        console.error('error', response);
                    });
            } else {
                // create
                cedenteService.create(vm.cedente)
                    .then(function success(response) {
                        if (response.success) {
                            $state.go('perfil-usuario', { tabIndex: 0 });
                        }
                        console.info('success', response);
                    }, function error(response) {
                        console.error('error', response);
                    });
            }
        }
    }
})();