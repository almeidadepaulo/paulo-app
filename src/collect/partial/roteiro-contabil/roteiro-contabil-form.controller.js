(function() {
    'use strict';

    angular.module('seeawayApp').controller('RoteiroContabilFormCtrl', RoteiroContabilFormCtrl);

    RoteiroContabilFormCtrl.$inject = ['$state', '$stateParams', '$mdDialog', 'roteiroContabilService', 'getData'];

    function RoteiroContabilFormCtrl($state, $stateParams, $mdDialog, roteiroContabilService, getData) {

        var vm = this;
        vm.init = init;
        vm.roteiroContabil = {};
        vm.getData = getData;
        vm.removeById = removeById;
        vm.cancel = cancel;
        vm.save = save;

        function init() {
            if ($stateParams.id) {
                vm.action = 'update';
                vm.getData.BKN509_CD_ROTCT = parseInt(vm.getData.BKN509_CD_ROTCT);
                vm.roteiroContabil = vm.getData;
            } else {
                vm.action = 'create';
                vm.roteiroContabil.BKN509_NR_CRED2 = '';
                vm.roteiroContabil.BKN509_NR_DEBT2 = '';
                vm.roteiroContabil.bkn509_ST_REVER = 'N';
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
                roteiroContabilService.removeById($stateParams.id)
                    .then(function success(response) {
                        console.info('success', response);
                        $state.go('roteiro-contabil');
                    }, function error(response) {
                        console.error('error', response);
                    });
            }, function() {
                // cancel
            });
        }

        function cancel() {
            $state.go('roteiro-contabil');
        }

        function save() {

            if ($stateParams.id) {
                //update
                roteiroContabilService.update($stateParams.id, vm.roteiroContabil)
                    .then(function success(response) {
                        console.info('success', response);
                        $state.go('roteiro-contabil');
                    }, function error(response) {
                        console.error('error', response);
                    });
            } else {
                // create
                roteiroContabilService.create(vm.roteiroContabil)
                    .then(function success(response) {
                        if (response.success) {
                            $state.go('roteiro-contabil');
                        }
                        console.info('success', response);
                    }, function error(response) {
                        console.error('error', response);
                    });
            }
        }
    }
})();