(function() {
    'use strict';

    angular.module('seeawayApp').controller('EmailPacoteFormCtrl', EmailPacoteFormCtrl);

    EmailPacoteFormCtrl.$inject = ['$state', '$stateParams', '$mdDialog', 'emailPacoteService', 'getData'];

    function EmailPacoteFormCtrl($state, $stateParams, $mdDialog, emailPacoteService, getData) {

        var vm = this;
        vm.init = init;
        vm.pacote = {};
        vm.getData = getData;
        vm.removeById = removeById;
        vm.cancel = cancel;
        vm.save = save;

        function init() {
            if ($stateParams.id) {
                vm.action = 'update';
                vm.getData.EM070_NR_PACOTE = parseInt(vm.getData.EM070_NR_PACOTE);
                vm.pacote = vm.getData;
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
                emailPacoteService.removeById($stateParams.id)
                    .then(function success(response) {
                        console.info('success', response);
                        $state.go('email-pacote');
                    }, function error(response) {
                        console.error('error', response);
                    });
            }, function() {
                // cancel
            });
        }

        function cancel() {
            $state.go('email-pacote');
        }

        function save() {

            if ($stateParams.id) {
                //update
                emailPacoteService.update($stateParams.id, vm.pacote)
                    .then(function success(response) {
                        console.info('success', response);
                        $state.go('email-pacote');
                    }, function error(response) {
                        console.error('error', response);
                    });
            } else {
                // create
                emailPacoteService.create(vm.pacote)
                    .then(function success(response) {
                        if (response.success) {
                            $state.go('email-pacote');
                        }
                        console.info('success', response);
                    }, function error(response) {
                        console.error('error', response);
                    });
            }
        }
    }
})();