(function() {
    'use strict';

    angular.module('seeawayApp').controller('SmsParametroFormCtrl', SmsParametroFormCtrl);

    SmsParametroFormCtrl.$inject = ['$state', '$stateParams', '$mdDialog', 'smsParametroService', 'getData'];

    function SmsParametroFormCtrl($state, $stateParams, $mdDialog, smsParametroService, getData) {

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

                vm.getData.MG000_QT_DIAS = parseInt(vm.getData.MG000_QT_DIAS);
                vm.getData.MG000_QT_MSG = parseInt(vm.getData.MG000_QT_MSG);
                vm.getData.MG000_PC_PROPOR = parseInt(vm.getData.MG000_PC_PROPOR);

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
                smsParametroService.removeById($stateParams.id)
                    .then(function success(response) {
                        console.info('success', response);
                        $state.go('menu', { id: 'sms' });
                    }, function error(response) {
                        console.error('error', response);
                    });
            }, function() {
                // cancel
            });
        }

        function cancel() {
            $state.go('menu', { id: 'sms' });
        }

        function save() {

            $stateParams.id = { MG000_NR_INST: 1 };

            if ($stateParams.id) {
                //update
                smsParametroService.update($stateParams.id, vm.pacote)
                    .then(function success(response) {
                        console.info('success', response);
                        $state.go('menu', { id: 'sms' });
                    }, function error(response) {
                        console.error('error', response);
                    });
            } else {
                // create
                smsParametroService.create(vm.pacote)
                    .then(function success(response) {
                        if (response.success) {
                            $state.go('menu', { id: 'sms' });
                        }
                        console.info('success', response);
                    }, function error(response) {
                        console.error('error', response);
                    });
            }
        }
    }
})();