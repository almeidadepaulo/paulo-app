(function() {
    'use strict';

    angular.module('seeawayApp').controller('SmsBlacklistFormCtrl', SmsBlacklistFormCtrl);

    SmsBlacklistFormCtrl.$inject = ['$state', '$stateParams', '$mdDialog', 'smsBlacklistService', 'getData',
        '$filter'
    ];

    function SmsBlacklistFormCtrl($state, $stateParams, $mdDialog, smsBlacklistService, getData,
        $filter) {

        var vm = this;
        vm.init = init;
        vm.blacklist = {};
        vm.getData = getData;
        vm.removeById = removeById;
        vm.cancel = cancel;
        vm.save = save;

        function init() {
            if ($stateParams.id) {
                vm.action = 'update';

                vm.getData.MG065_NR_DDD = parseInt(vm.getData.MG065_NR_DDD);
                vm.getData.MG065_NR_CEL = parseInt(vm.getData.MG065_NR_CEL);
                vm.getData.MG065_NR_CPFCNPJ = $filter('padLeft')(vm.getData.MG065_NR_CPFCNPJ, '00000000000');
                vm.blacklist = vm.getData;
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
                smsBlacklistService.removeById($stateParams.id)
                    .then(function success(response) {
                        console.info('success', response);
                        $state.go('sms-blacklist');
                    }, function error(response) {
                        console.error('error', response);
                    });
            }, function() {
                // cancel
            });
        }

        function cancel() {
            $state.go('sms-blacklist');
        }

        function save() {

            if ($stateParams.id) {
                //update
                smsBlacklistService.update($stateParams.id, vm.blacklist)
                    .then(function success(response) {
                        console.info('success', response);
                        $state.go('sms-blacklist');
                    }, function error(response) {
                        console.error('error', response);
                    });
            } else {
                // create
                smsBlacklistService.create(vm.blacklist)
                    .then(function success(response) {
                        if (response.success) {
                            $state.go('sms-blacklist');
                        }
                        console.info('success', response);
                    }, function error(response) {
                        console.error('error', response);
                    });
            }
        }
    }
})();