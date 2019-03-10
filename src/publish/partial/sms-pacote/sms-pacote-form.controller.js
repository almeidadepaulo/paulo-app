(function() {
    'use strict';

    angular.module('seeawayApp').controller('SmsPacoteFormCtrl', SmsPacoteFormCtrl);

    SmsPacoteFormCtrl.$inject = ['$state', '$stateParams', '$mdDialog', 'smsPacoteService', 'getData'];

    function SmsPacoteFormCtrl($state, $stateParams, $mdDialog, smsPacoteService, getData) {

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
                vm.getData.MG070_NR_PACOTE = parseInt(vm.getData.MG070_NR_PACOTE);
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
                smsPacoteService.removeById($stateParams.id)
                    .then(function success(response) {
                        console.info('success', response);
                        $state.go('sms-pacote');
                    }, function error(response) {
                        console.error('error', response);
                    });
            }, function() {
                // cancel
            });
        }

        function cancel() {
            $state.go('sms-pacote');
        }

        function save() {

            if ($stateParams.id) {
                //update
                smsPacoteService.update($stateParams.id, vm.pacote)
                    .then(function success(response) {
                        console.info('success', response);
                        $state.go('sms-pacote');
                    }, function error(response) {
                        console.error('error', response);
                    });
            } else {
                // create
                smsPacoteService.create(vm.pacote)
                    .then(function success(response) {
                        if (response.success) {
                            $state.go('sms-pacote');
                        }
                        console.info('success', response);
                    }, function error(response) {
                        console.error('error', response);
                    });
            }
        }
    }
})();