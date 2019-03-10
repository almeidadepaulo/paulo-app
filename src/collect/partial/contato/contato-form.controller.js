(function() {
    'use strict';

    angular.module('seeawayApp').controller('ContatoFormCtrl', ContatoFormCtrl);

    ContatoFormCtrl.$inject = ['$state', '$stateParams', '$mdDialog', 'contatoService', 'getData'];

    function ContatoFormCtrl($state, $stateParams, $mdDialog, contatoService, getData) {

        var vm = this;
        vm.init = init;
        vm.contato = {};
        vm.getData = getData;
        vm.removeById = removeById;
        vm.cancel = cancel;
        vm.save = save;

        function init() {

            if ($stateParams.id) {
                vm.action = 'update';
                vm.getData.CB054_NM_EMAIL = vm.getData.CB054_NM_EMAIL.trim();
                vm.contato = vm.getData;
            } else {
                vm.action = 'create';
                vm.contato.CB054_NR_CEL = '';
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
                contatoService.removeById($stateParams.id)
                    .then(function success(response) {
                        console.info('success', response);
                        $state.go('contato');
                    }, function error(response) {
                        console.error('error', response);
                    });
            }, function() {
                // cancel
            });
        }

        function cancel() {
            $state.go('contato');
        }

        function save() {

            if ($stateParams.id) {
                //update
                contatoService.update($stateParams.id, vm.contato)
                    .then(function success(response) {
                        console.info('success', response);
                        $state.go('contato');
                    }, function error(response) {
                        console.error('error', response);
                    });
            } else {
                // create
                contatoService.create(vm.contato)
                    .then(function success(response) {
                        if (response.success) {
                            $state.go('contato');
                        }
                        console.info('success', response);
                    }, function error(response) {
                        console.error('error', response);
                    });
            }
        }
    }
})();