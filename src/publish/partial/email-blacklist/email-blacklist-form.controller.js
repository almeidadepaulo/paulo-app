(function() {
    'use strict';

    angular.module('seeawayApp').controller('EmailBlacklistFormCtrl', EmailBlacklistFormCtrl);

    EmailBlacklistFormCtrl.$inject = ['$state', '$stateParams', '$mdDialog', 'emailBlacklistService', 'getData',
        '$filter'
    ];

    function EmailBlacklistFormCtrl($state, $stateParams, $mdDialog, emailBlacklistService, getData,
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
                vm.getData.EM065_NR_CPFCNPJ = $filter('padLeft')(vm.getData.EM065_NR_CPFCNPJ, '00000000000');
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
                emailBlacklistService.removeById($stateParams.id)
                    .then(function success(response) {
                        console.info('success', response);
                        $state.go('email-blacklist');
                    }, function error(response) {
                        console.error('error', response);
                    });
            }, function() {
                // cancel
            });
        }

        function cancel() {
            $state.go('email-blacklist');
        }

        function save() {

            if ($stateParams.id) {
                //update
                emailBlacklistService.update($stateParams.id, vm.blacklist)
                    .then(function success(response) {
                        console.info('success', response);
                        $state.go('email-blacklist');
                    }, function error(response) {
                        console.error('error', response);
                    });
            } else {
                // create
                emailBlacklistService.create(vm.blacklist)
                    .then(function success(response) {
                        if (response.success) {
                            $state.go('email-blacklist');
                        }
                        console.info('success', response);
                    }, function error(response) {
                        console.error('error', response);
                    });
            }
        }
    }
})();