(function() {
    'use strict';

    angular.module('seeawayApp').controller('EmailBrokerFormCtrl', EmailBrokerFormCtrl);

    EmailBrokerFormCtrl.$inject = ['$state', '$stateParams', '$mdDialog', 'emailBrokerService', 'getData'];

    function EmailBrokerFormCtrl($state, $stateParams, $mdDialog, emailBrokerService, getData) {

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

                vm.getData.EM050_NR_BROKER = parseInt(vm.getData.EM050_NR_BROKER);
                vm.broker = vm.getData;
            } else {
                vm.action = 'create';
                vm.broker.EM050_ID_ATIVO = 0;
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
                emailBrokerService.removeById($stateParams.id)
                    .then(function success(response) {
                        console.info('success', response);
                        $state.go('email-broker');
                    }, function error(response) {
                        console.error('error', response);
                    });
            }, function() {
                // cancel
            });
        }

        function cancel() {
            $state.go('email-broker');
        }

        function save() {

            if ($stateParams.id) {
                //update
                emailBrokerService.update($stateParams.id, vm.broker)
                    .then(function success(response) {
                        console.info('success', response);
                        $state.go('email-broker');
                    }, function error(response) {
                        console.error('error', response);
                    });
            } else {
                // create
                emailBrokerService.create(vm.broker)
                    .then(function success(response) {
                        if (response.success) {
                            $state.go('email-broker');
                        }
                        console.info('success', response);
                    }, function error(response) {
                        console.error('error', response);
                    });
            }
        }
    }
})();