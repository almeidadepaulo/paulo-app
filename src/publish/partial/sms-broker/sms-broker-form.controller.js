(function() {
    'use strict';

    angular.module('seeawayApp').controller('SmsBrokerFormCtrl', SmsBrokerFormCtrl);

    SmsBrokerFormCtrl.$inject = ['$state', '$stateParams', '$mdDialog', 'smsBrokerService', 'getData'];

    function SmsBrokerFormCtrl($state, $stateParams, $mdDialog, smsBrokerService, getData) {

        var vm = this;
        vm.init = init;
        vm.broker = {};
        vm.getData = getData;
        vm.removeById = removeById;
        vm.cancel = cancel;
        vm.save = save;

        function init() {

            if ($stateParams.id) {
                vm.action = 'update';
                vm.getData.MG050_NR_BROKER = parseInt(vm.getData.MG050_NR_BROKER);
                vm.broker = vm.getData;
                vm.showSenha = 'password';
            } else {
                vm.action = 'create';
                vm.broker.MG050_ID_ATIVO = 0;
                vm.showSenha = 'text';
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
                smsBrokerService.removeById($stateParams.id)
                    .then(function success(response) {
                        console.info('success', response);
                        $state.go('sms-broker');
                    }, function error(response) {
                        console.error('error', response);
                    });
            }, function() {
                // cancel
            });
        }

        function cancel() {
            $state.go('sms-broker');
        }

        function save() {

            if ($stateParams.id) {
                //update
                smsBrokerService.update($stateParams.id, vm.broker)
                    .then(function success(response) {
                        console.info('success', response);
                        $state.go('sms-broker');
                    }, function error(response) {
                        console.error('error', response);
                    });
            } else {
                // create
                smsBrokerService.create(vm.broker)
                    .then(function success(response) {
                        if (response.success) {
                            $state.go('sms-broker');
                        }
                        console.info('success', response);
                    }, function error(response) {
                        console.error('error', response);
                    });
            }
        }
    }
})();